// MediaPipeLLMExample.kt
// Esempio di utilizzo di MediaPipe LLM Inference API con modelli Gemma custom
// Permette di usare modelli GGUF/LiteRT scaricati

package com.example.mediapipellm

import android.content.Context
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.google.mediapipe.tasks.genai.llminference.LlmInference
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.File

// MARK: - LLM Manager

/**
 * Manager per MediaPipe LLM Inference
 * Gestisce il ciclo di vita del modello e le inferenze
 */
class MediaPipeLlmManager(private val context: Context) {

    private var llmInference: LlmInference? = null

    data class ModelConfig(
        val modelPath: String,
        val maxTokens: Int = 1024,
        val temperature: Float = 0.7f,
        val topK: Int = 40,
        val randomSeed: Int = 42
    )

    /**
     * Inizializza il modello LLM
     */
    suspend fun initialize(config: ModelConfig): Result<Unit> = withContext(Dispatchers.IO) {
        try {
            // Verifica che il file esista
            val modelFile = File(config.modelPath)
            if (!modelFile.exists()) {
                return@withContext Result.failure(
                    IllegalStateException("Modello non trovato: ${config.modelPath}")
                )
            }

            // Configura le opzioni
            val options = LlmInference.LlmInferenceOptions.builder()
                .setModelPath(config.modelPath)
                .setMaxTokens(config.maxTokens)
                .setTemperature(config.temperature)
                .setTopK(config.topK)
                .setRandomSeed(config.randomSeed)
                .build()

            // Crea l'istanza
            llmInference = LlmInference.createFromOptions(context, options)

            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    /**
     * Genera risposta (sincrona)
     */
    suspend fun generate(prompt: String): Result<String> = withContext(Dispatchers.IO) {
        try {
            val inference = llmInference
                ?: return@withContext Result.failure(
                    IllegalStateException("Modello non inizializzato")
                )

            val response = inference.generateResponse(prompt)
            Result.success(response)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    /**
     * Genera risposta con streaming
     */
    suspend fun generateStreaming(
        prompt: String,
        onPartialResult: (String) -> Unit
    ): Result<String> = withContext(Dispatchers.IO) {
        try {
            val inference = llmInference
                ?: return@withContext Result.failure(
                    IllegalStateException("Modello non inizializzato")
                )

            val fullResponse = StringBuilder()

            inference.generateResponseAsync(prompt) { partialResult, done ->
                fullResponse.append(partialResult)
                onPartialResult(fullResponse.toString())
            }

            Result.success(fullResponse.toString())
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    /**
     * Rilascia le risorse
     */
    fun release() {
        llmInference?.close()
        llmInference = null
    }
}

// MARK: - ViewModel

class MediaPipeLlmViewModel : ViewModel() {

    private var llmManager: MediaPipeLlmManager? = null

    private val _isModelLoaded = MutableStateFlow(false)
    val isModelLoaded: StateFlow<Boolean> = _isModelLoaded.asStateFlow()

    private val _isGenerating = MutableStateFlow(false)
    val isGenerating: StateFlow<Boolean> = _isGenerating.asStateFlow()

    private val _response = MutableStateFlow("")
    val response: StateFlow<String> = _response.asStateFlow()

    private val _error = MutableStateFlow<String?>(null)
    val error: StateFlow<String?> = _error.asStateFlow()

    private val _modelInfo = MutableStateFlow<String?>(null)
    val modelInfo: StateFlow<String?> = _modelInfo.asStateFlow()

    /**
     * Inizializza con un modello specifico
     */
    fun loadModel(context: Context, modelPath: String) {
        viewModelScope.launch {
            _error.value = null
            _modelInfo.value = "Caricamento modello..."

            llmManager = MediaPipeLlmManager(context)

            val config = MediaPipeLlmManager.ModelConfig(
                modelPath = modelPath,
                maxTokens = 1024,
                temperature = 0.7f
            )

            llmManager?.initialize(config)
                ?.onSuccess {
                    _isModelLoaded.value = true
                    _modelInfo.value = "Modello caricato: ${File(modelPath).name}"
                }
                ?.onFailure { e ->
                    _error.value = "Errore caricamento: ${e.message}"
                    _modelInfo.value = null
                }
        }
    }

    /**
     * Genera risposta con streaming
     */
    fun generate(prompt: String) {
        if (!_isModelLoaded.value) {
            _error.value = "Modello non caricato"
            return
        }

        viewModelScope.launch {
            _isGenerating.value = true
            _response.value = ""
            _error.value = null

            llmManager?.generateStreaming(prompt) { partial ->
                _response.value = partial
            }?.onFailure { e ->
                _error.value = "Errore: ${e.message}"
            }

            _isGenerating.value = false
        }
    }

    override fun onCleared() {
        super.onCleared()
        llmManager?.release()
    }
}

// MARK: - Composables

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MediaPipeLlmScreen(viewModel: MediaPipeLlmViewModel) {

    val context = LocalContext.current
    val isModelLoaded by viewModel.isModelLoaded.collectAsState()
    val isGenerating by viewModel.isGenerating.collectAsState()
    val response by viewModel.response.collectAsState()
    val error by viewModel.error.collectAsState()
    val modelInfo by viewModel.modelInfo.collectAsState()

    var prompt by remember { mutableStateOf("") }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("MediaPipe LLM") }
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .padding(16.dp)
        ) {
            // Model info/status
            Card(
                modifier = Modifier.fillMaxWidth()
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(
                        text = "Stato modello",
                        style = MaterialTheme.typography.titleSmall
                    )
                    Spacer(modifier = Modifier.height(8.dp))

                    if (modelInfo != null) {
                        Text(
                            text = modelInfo!!,
                            style = MaterialTheme.typography.bodyMedium
                        )
                    }

                    if (!isModelLoaded) {
                        Spacer(modifier = Modifier.height(8.dp))
                        Button(
                            onClick = {
                                // Path del modello - in produzione usa file picker
                                val modelPath = context.getExternalFilesDir(null)
                                    ?.resolve("models/gemma-2b-it-q4.task")
                                    ?.absolutePath ?: ""
                                viewModel.loadModel(context, modelPath)
                            }
                        ) {
                            Text("Carica modello")
                        }

                        Text(
                            text = "Posiziona il file .task in: /Android/data/[package]/files/models/",
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Input prompt
            OutlinedTextField(
                value = prompt,
                onValueChange = { prompt = it },
                modifier = Modifier.fillMaxWidth(),
                label = { Text("Prompt") },
                placeholder = { Text("Scrivi il tuo prompt...") },
                minLines = 3,
                maxLines = 5,
                enabled = isModelLoaded && !isGenerating
            )

            Spacer(modifier = Modifier.height(8.dp))

            // Generate button
            Button(
                onClick = { viewModel.generate(prompt) },
                modifier = Modifier.fillMaxWidth(),
                enabled = isModelLoaded && prompt.isNotBlank() && !isGenerating
            ) {
                if (isGenerating) {
                    CircularProgressIndicator(
                        modifier = Modifier.size(16.dp),
                        strokeWidth = 2.dp,
                        color = MaterialTheme.colorScheme.onPrimary
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text("Generando...")
                } else {
                    Text("Genera risposta")
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Error
            error?.let { errorMessage ->
                Card(
                    colors = CardDefaults.cardColors(
                        containerColor = MaterialTheme.colorScheme.errorContainer
                    )
                ) {
                    Text(
                        text = errorMessage,
                        modifier = Modifier.padding(12.dp),
                        color = MaterialTheme.colorScheme.onErrorContainer
                    )
                }
                Spacer(modifier = Modifier.height(16.dp))
            }

            // Response
            if (response.isNotEmpty()) {
                Text(
                    text = "Risposta:",
                    style = MaterialTheme.typography.titleSmall
                )
                Spacer(modifier = Modifier.height(8.dp))

                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .weight(1f)
                ) {
                    Text(
                        text = response,
                        modifier = Modifier.padding(16.dp)
                    )
                }
            }
        }
    }
}

// MARK: - Activity

class MediaPipeLLMActivity : ComponentActivity() {

    private val viewModel = MediaPipeLlmViewModel()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme {
                MediaPipeLlmScreen(viewModel = viewModel)
            }
        }
    }
}
