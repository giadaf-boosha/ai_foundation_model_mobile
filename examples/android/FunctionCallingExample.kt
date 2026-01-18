// FunctionCallingExample.kt
// Esempio di Function Calling con FunctionGemma su Android
// Mostra come implementare tool/function calling on-device

package com.example.functioncalling

import android.content.Context
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
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
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.*

// MARK: - Function Definitions

/**
 * Definizione di una funzione che il modello può chiamare
 */
@Serializable
data class FunctionDefinition(
    val name: String,
    val description: String,
    val parameters: Map<String, ParameterDef>
)

@Serializable
data class ParameterDef(
    val type: String,
    val description: String,
    val required: Boolean = true,
    val enum: List<String>? = null
)

/**
 * Risultato del parsing di una function call
 */
@Serializable
data class FunctionCall(
    val function: String,
    val parameters: Map<String, JsonElement>
)

// MARK: - Available Functions

object AvailableFunctions {

    val getWeather = FunctionDefinition(
        name = "get_weather",
        description = "Ottiene le condizioni meteo attuali per una città",
        parameters = mapOf(
            "city" to ParameterDef(
                type = "string",
                description = "Nome della città"
            ),
            "units" to ParameterDef(
                type = "string",
                description = "Unità di temperatura",
                required = false,
                enum = listOf("celsius", "fahrenheit")
            )
        )
    )

    val setAlarm = FunctionDefinition(
        name = "set_alarm",
        description = "Imposta una sveglia",
        parameters = mapOf(
            "time" to ParameterDef(
                type = "string",
                description = "Orario in formato HH:MM"
            ),
            "label" to ParameterDef(
                type = "string",
                description = "Etichetta della sveglia",
                required = false
            )
        )
    )

    val sendMessage = FunctionDefinition(
        name = "send_message",
        description = "Invia un messaggio a un contatto",
        parameters = mapOf(
            "recipient" to ParameterDef(
                type = "string",
                description = "Nome del destinatario"
            ),
            "message" to ParameterDef(
                type = "string",
                description = "Contenuto del messaggio"
            )
        )
    )

    val openApp = FunctionDefinition(
        name = "open_app",
        description = "Apre un'applicazione",
        parameters = mapOf(
            "app_name" to ParameterDef(
                type = "string",
                description = "Nome dell'app da aprire"
            )
        )
    )

    val all = listOf(getWeather, setAlarm, sendMessage, openApp)
}

// MARK: - Function Executor

/**
 * Esegue le funzioni chiamate dal modello
 */
class FunctionExecutor {

    fun execute(call: FunctionCall): String {
        return when (call.function) {
            "get_weather" -> executeGetWeather(call.parameters)
            "set_alarm" -> executeSetAlarm(call.parameters)
            "send_message" -> executeSendMessage(call.parameters)
            "open_app" -> executeOpenApp(call.parameters)
            else -> "Funzione sconosciuta: ${call.function}"
        }
    }

    private fun executeGetWeather(params: Map<String, JsonElement>): String {
        val city = params["city"]?.jsonPrimitive?.content ?: "sconosciuta"
        val units = params["units"]?.jsonPrimitive?.content ?: "celsius"

        // Simulazione - in produzione usa API meteo
        val temps = mapOf(
            "roma" to 18, "milano" to 12, "napoli" to 20,
            "torino" to 10, "firenze" to 15
        )
        val temp = temps[city.lowercase()] ?: 15

        val displayTemp = if (units == "fahrenheit") {
            "${temp * 9 / 5 + 32}°F"
        } else {
            "${temp}°C"
        }

        return "Meteo a $city: $displayTemp, parzialmente nuvoloso"
    }

    private fun executeSetAlarm(params: Map<String, JsonElement>): String {
        val time = params["time"]?.jsonPrimitive?.content ?: "00:00"
        val label = params["label"]?.jsonPrimitive?.content ?: "Sveglia"

        // In produzione usa AlarmManager
        return "Sveglia impostata alle $time: $label"
    }

    private fun executeSendMessage(params: Map<String, JsonElement>): String {
        val recipient = params["recipient"]?.jsonPrimitive?.content ?: "?"
        val message = params["message"]?.jsonPrimitive?.content ?: ""

        // In produzione usa SMS/messaging API
        return "Messaggio inviato a $recipient: \"$message\""
    }

    private fun executeOpenApp(params: Map<String, JsonElement>): String {
        val appName = params["app_name"]?.jsonPrimitive?.content ?: "?"

        // In produzione usa Intent per aprire l'app
        return "Apertura app: $appName"
    }
}

// MARK: - Prompt Builder

object PromptBuilder {

    /**
     * Costruisce il prompt con le definizioni delle funzioni
     */
    fun buildPrompt(userInput: String, functions: List<FunctionDefinition>): String {
        val functionsJson = buildFunctionsJson(functions)

        return """
You are a helpful assistant that can call functions to help users.

Available functions:
$functionsJson

User request: $userInput

If you need to call a function, respond ONLY with a JSON object in this exact format:
{"function": "function_name", "parameters": {"param1": "value1"}}

If no function is needed, respond naturally in Italian.
        """.trimIndent()
    }

    private fun buildFunctionsJson(functions: List<FunctionDefinition>): String {
        return functions.joinToString("\n\n") { fn ->
            """
- ${fn.name}: ${fn.description}
  Parameters: ${fn.parameters.map { (k, v) -> "$k (${v.type}): ${v.description}" }.joinToString(", ")}
            """.trimIndent()
        }
    }

    /**
     * Prova a parsare una function call dalla risposta
     */
    fun parseFunctionCall(response: String): FunctionCall? {
        return try {
            // Cerca JSON nella risposta
            val jsonMatch = Regex("""\{[^}]+\}""").find(response)
            val jsonStr = jsonMatch?.value ?: return null

            val json = Json.parseToJsonElement(jsonStr).jsonObject

            val functionName = json["function"]?.jsonPrimitive?.content
                ?: return null

            val parameters = json["parameters"]?.jsonObject
                ?.mapValues { it.value }
                ?: emptyMap()

            FunctionCall(functionName, parameters)
        } catch (e: Exception) {
            null
        }
    }
}

// MARK: - ViewModel

class FunctionCallingViewModel : ViewModel() {

    data class LogEntry(
        val id: String = java.util.UUID.randomUUID().toString(),
        val type: EntryType,
        val content: String,
        val details: String? = null
    )

    enum class EntryType {
        USER_INPUT, MODEL_RESPONSE, FUNCTION_CALL, FUNCTION_RESULT, ERROR
    }

    private val _log = MutableStateFlow<List<LogEntry>>(emptyList())
    val log: StateFlow<List<LogEntry>> = _log.asStateFlow()

    private val _isProcessing = MutableStateFlow(false)
    val isProcessing: StateFlow<Boolean> = _isProcessing.asStateFlow()

    private var llmInference: LlmInference? = null
    private val functionExecutor = FunctionExecutor()

    fun initialize(context: Context, modelPath: String) {
        viewModelScope.launch {
            withContext(Dispatchers.IO) {
                try {
                    val options = LlmInference.LlmInferenceOptions.builder()
                        .setModelPath(modelPath)
                        .setMaxTokens(256)
                        .setTemperature(0.2f) // Bassa per output più deterministico
                        .build()

                    llmInference = LlmInference.createFromOptions(context, options)

                    addLog(EntryType.MODEL_RESPONSE, "Modello FunctionGemma caricato")
                } catch (e: Exception) {
                    addLog(EntryType.ERROR, "Errore caricamento: ${e.message}")
                }
            }
        }
    }

    fun processInput(userInput: String) {
        if (llmInference == null) {
            addLog(EntryType.ERROR, "Modello non caricato")
            return
        }

        viewModelScope.launch {
            _isProcessing.value = true
            addLog(EntryType.USER_INPUT, userInput)

            withContext(Dispatchers.IO) {
                try {
                    // Costruisci prompt con funzioni
                    val prompt = PromptBuilder.buildPrompt(
                        userInput,
                        AvailableFunctions.all
                    )

                    // Genera risposta
                    val response = llmInference!!.generateResponse(prompt)
                    addLog(EntryType.MODEL_RESPONSE, response)

                    // Prova a parsare come function call
                    val functionCall = PromptBuilder.parseFunctionCall(response)

                    if (functionCall != null) {
                        addLog(
                            EntryType.FUNCTION_CALL,
                            "Chiamata: ${functionCall.function}",
                            "Parametri: ${functionCall.parameters}"
                        )

                        // Esegui la funzione
                        val result = functionExecutor.execute(functionCall)
                        addLog(EntryType.FUNCTION_RESULT, result)
                    }

                } catch (e: Exception) {
                    addLog(EntryType.ERROR, "Errore: ${e.message}")
                }
            }

            _isProcessing.value = false
        }
    }

    private fun addLog(type: EntryType, content: String, details: String? = null) {
        _log.value = _log.value + LogEntry(
            type = type,
            content = content,
            details = details
        )
    }

    fun clearLog() {
        _log.value = emptyList()
    }
}

// MARK: - Composables

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FunctionCallingScreen(viewModel: FunctionCallingViewModel) {

    val log by viewModel.log.collectAsState()
    val isProcessing by viewModel.isProcessing.collectAsState()

    var input by remember { mutableStateOf("") }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Function Calling") },
                actions = {
                    IconButton(onClick = { viewModel.clearLog() }) {
                        Icon(Icons.Default.Delete, "Pulisci")
                    }
                }
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
        ) {
            // Available functions chips
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp, vertical = 8.dp),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                AvailableFunctions.all.take(4).forEach { fn ->
                    AssistChip(
                        onClick = { },
                        label = { Text(fn.name.replace("_", " "), style = MaterialTheme.typography.labelSmall) },
                        leadingIcon = {
                            Icon(
                                imageVector = iconForFunction(fn.name),
                                contentDescription = null,
                                modifier = Modifier.size(16.dp)
                            )
                        }
                    )
                }
            }

            Divider()

            // Log
            LazyColumn(
                modifier = Modifier
                    .weight(1f)
                    .fillMaxWidth()
                    .padding(16.dp),
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                items(log, key = { it.id }) { entry ->
                    LogEntryCard(entry = entry)
                }

                if (isProcessing) {
                    item {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            CircularProgressIndicator(modifier = Modifier.size(16.dp))
                            Spacer(modifier = Modifier.width(8.dp))
                            Text("Elaborazione...", style = MaterialTheme.typography.bodySmall)
                        }
                    }
                }
            }

            // Quick actions
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                listOf(
                    "Che tempo fa a Roma?",
                    "Sveglia alle 7:00"
                ).forEach { suggestion ->
                    SuggestionChip(
                        onClick = {
                            input = suggestion
                            viewModel.processInput(suggestion)
                            input = ""
                        },
                        label = { Text(suggestion, style = MaterialTheme.typography.labelSmall) },
                        enabled = !isProcessing
                    )
                }
            }

            Spacer(modifier = Modifier.height(8.dp))

            // Input
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                OutlinedTextField(
                    value = input,
                    onValueChange = { input = it },
                    modifier = Modifier.weight(1f),
                    placeholder = { Text("Es: Manda un messaggio a Mario...") },
                    enabled = !isProcessing,
                    singleLine = true
                )

                Spacer(modifier = Modifier.width(8.dp))

                IconButton(
                    onClick = {
                        val text = input
                        input = ""
                        viewModel.processInput(text)
                    },
                    enabled = input.isNotBlank() && !isProcessing
                ) {
                    Icon(Icons.Default.Send, "Invia")
                }
            }
        }
    }
}

@Composable
fun LogEntryCard(entry: FunctionCallingViewModel.LogEntry) {
    val (containerColor, icon) = when (entry.type) {
        FunctionCallingViewModel.EntryType.USER_INPUT ->
            MaterialTheme.colorScheme.primaryContainer to Icons.Default.Person
        FunctionCallingViewModel.EntryType.MODEL_RESPONSE ->
            MaterialTheme.colorScheme.secondaryContainer to Icons.Default.SmartToy
        FunctionCallingViewModel.EntryType.FUNCTION_CALL ->
            MaterialTheme.colorScheme.tertiaryContainer to Icons.Default.Code
        FunctionCallingViewModel.EntryType.FUNCTION_RESULT ->
            MaterialTheme.colorScheme.surfaceVariant to Icons.Default.CheckCircle
        FunctionCallingViewModel.EntryType.ERROR ->
            MaterialTheme.colorScheme.errorContainer to Icons.Default.Error
    }

    Card(
        colors = CardDefaults.cardColors(containerColor = containerColor),
        shape = RoundedCornerShape(12.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(12.dp),
            verticalAlignment = Alignment.Top
        ) {
            Icon(
                imageVector = icon,
                contentDescription = null,
                modifier = Modifier.size(20.dp)
            )
            Spacer(modifier = Modifier.width(12.dp))
            Column {
                Text(
                    text = entry.content,
                    style = MaterialTheme.typography.bodyMedium
                )
                entry.details?.let { details ->
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(
                        text = details,
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
        }
    }
}

fun iconForFunction(name: String): ImageVector {
    return when (name) {
        "get_weather" -> Icons.Default.Cloud
        "set_alarm" -> Icons.Default.Alarm
        "send_message" -> Icons.Default.Message
        "open_app" -> Icons.Default.Launch
        else -> Icons.Default.Functions
    }
}

// MARK: - Activity

class FunctionCallingActivity : ComponentActivity() {

    private val viewModel = FunctionCallingViewModel()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Inizializza con path del modello FunctionGemma
        val modelPath = getExternalFilesDir(null)
            ?.resolve("models/functiongemma-270m.task")
            ?.absolutePath ?: ""

        viewModel.initialize(this, modelPath)

        setContent {
            MaterialTheme {
                FunctionCallingScreen(viewModel = viewModel)
            }
        }
    }
}
