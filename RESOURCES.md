# Risorse per Foundation Model On-Device Mobile

> Una raccolta curata di link a documentazione ufficiale, tutorial, articoli, repository GitHub, paper accademici e cookbook per sviluppare applicazioni AI on-device per iOS e Android.

---

## Indice

1. [Documentazione ufficiale](#1-documentazione-ufficiale)
2. [Video e corsi](#2-video-e-corsi)
3. [Tutorial e guide pratiche](#3-tutorial-e-guide-pratiche)
4. [Articoli Medium e Substack](#4-articoli-medium-e-substack)
5. [Repository GitHub](#5-repository-github)
6. [Paper accademici](#6-paper-accademici)
7. [Cookbook e notebook](#7-cookbook-e-notebook)
8. [Tool e framework](#8-tool-e-framework)
9. [Community e blog](#9-community-e-blog)

---

## 1. Documentazione ufficiale

### Apple

| Risorsa | Descrizione |
|---------|-------------|
| [Foundation Models Framework](https://developer.apple.com/documentation/FoundationModels) | Documentazione ufficiale del framework per accedere all'LLM on-device di Apple |
| [Generating content with Foundation Models](https://developer.apple.com/documentation/FoundationModels/generating-content-and-performing-tasks-with-foundation-models) | Guida alla generazione di contenuti |
| [TN3193: Managing Context Window](https://developer.apple.com/documentation/technotes/tn3193-managing-the-on-device-foundation-model-s-context-window) | Tech note sulla gestione del context window |
| [Core ML Documentation](https://developer.apple.com/documentation/coreml) | Framework per modelli ML custom su Apple |
| [Core ML Tools Guide](https://apple.github.io/coremltools/docs-guides/source/introductory-quickstart.html) | Guida alla conversione modelli in Core ML |
| [Machine Learning Guide WWDC25](https://developer.apple.com/wwdc25/guides/machine-learning/) | Guida ML per WWDC25 |

### Google

| Risorsa | Descrizione |
|---------|-------------|
| [Gemini Nano Overview](https://developer.android.com/ai/gemini-nano) | Panoramica di Gemini Nano per Android |
| [ML Kit GenAI APIs](https://developers.google.com/ml-kit/genai) | API GenAI per ML Kit |
| [ML Kit GenAI Android](https://developer.android.com/ai/gemini-nano/ml-kit-genai) | Integrazione ML Kit GenAI su Android |
| [Prompt API Guide](https://developers.google.com/ml-kit/genai/prompt/android) | Guida alla Prompt API |
| [Prompt API - Get Started](https://developers.google.com/ml-kit/genai/prompt/android/get-started) | Quick start per Prompt API |
| [Prompt Design Guide](https://developers.google.com/ml-kit/genai/prompt/android/prompt-design) | Best practice per prompt design |
| [MediaPipe LLM Inference](https://ai.google.dev/edge/mediapipe/solutions/genai/llm_inference) | Inference LLM con MediaPipe |
| [MediaPipe LLM Android](https://ai.google.dev/edge/mediapipe/solutions/genai/llm_inference/android) | Guida Android per MediaPipe LLM |
| [Gemma Mobile Deployment](https://ai.google.dev/gemma/docs/integrations/mobile) | Deploy di Gemma su mobile |
| [Google AI Edge SDK](https://developer.android.com/ai/gemini-nano/ai-edge-sdk) | SDK per AI on-device |
| [Function Calling with Gemma](https://ai.google.dev/gemma/docs/capabilities/function-calling) | Function calling con Gemma |
| [FunctionGemma Guide](https://ai.google.dev/gemma/docs/functiongemma/full-function-calling-sequence-with-functiongemma) | Guida completa a FunctionGemma |

### Apple Machine Learning Research

| Risorsa | Descrizione |
|---------|-------------|
| [Foundation Models 2025 Updates](https://machinelearning.apple.com/research/apple-foundation-models-2025-updates) | Aggiornamenti 2025 ai Foundation Models |
| [Foundation Models Tech Report 2025](https://machinelearning.apple.com/research/apple-foundation-models-tech-report-2025) | Report tecnico dettagliato |
| [Introducing Foundation Models](https://machinelearning.apple.com/research/introducing-apple-foundation-models) | Introduzione ai modelli Apple |

---

## 2. Video e corsi

### WWDC25 - Apple

| Video | Descrizione |
|-------|-------------|
| [Meet the Foundation Models framework](https://developer.apple.com/videos/play/wwdc2025/286/) | Introduzione al framework (overview) |
| [Deep dive into Foundation Models](https://developer.apple.com/videos/play/wwdc2025/301/) | Approfondimento tecnico su guided generation |
| [Code-along: Bring on-device AI to your app](https://developer.apple.com/videos/play/wwdc2025/259/) | Tutorial pratico con SwiftUI |
| [Explore LLM on Apple silicon with MLX](https://developer.apple.com/videos/play/wwdc2025/298/) | LLM con MLX su Apple Silicon |

### Google I/O 2025

| Video | Descrizione |
|-------|-------------|
| [Gemini Nano on Android: Building with on-device gen AI](https://io.google/2025/explore/technical-session-14) | Sessione tecnica su Gemini Nano |

### Codelabs e learning paths

| Risorsa | Descrizione |
|---------|-------------|
| [LLM on Android with Keras and TensorFlow Lite](https://developers.google.com/learn/pathways/llm-on-android) | Pathway completo per deploy LLM su Android |
| [On-device LLMs with Keras and TFLite](https://codelabs.developers.google.com/kerasnlp-tflite) | Codelab pratico step-by-step |

---

## 3. Tutorial e guide pratiche

### iOS / Apple

| Titolo | Autore/Fonte | Link |
|--------|--------------|------|
| Getting Started with Apple's Foundation Models | Artem Novichkov | [Blog](https://artemnovichkov.com/blog/getting-started-with-apple-foundation-models) |
| The Ultimate Guide To The Foundation Models Framework | AzamSharp | [Blog](https://azamsharp.com/2025/06/18/the-ultimate-guide-to-the-foundation-models-framework.html) |
| An Introduction to Apple's Foundation Model Framework | Superwall | [Blog](https://superwall.com/blog/an-introduction-to-apples-foundation-model-framework/) |
| Step-by-step guide to run LLM on iPhone with MLX | Awni Hannun | [GitHub Gist](https://gist.github.com/awni/fe4f96c21ead68e60191190cbc1c129b) |
| Implementing Local AI on iOS with llama.cpp | Efficient Coder | [Blog](https://www.xugj520.cn/en/archives/local-ai-ios-llama-cpp-guide.html) |
| Running Phi models on iOS with Apple MLX Framework | Strathweb | [Blog](https://www.strathweb.com/2025/03/running-phi-models-on-ios-with-apple-mlx-framework/) |
| Releasing Swift Transformers: Run On-Device LLMs | Hugging Face | [Blog](https://huggingface.co/blog/swift-coreml-llm) |
| Converting Models to Core ML | Hugging Face | [Blog](https://huggingface.co/blog/fguzman82/frompytorch-to-coreml) |

### Android / Google

| Titolo | Autore/Fonte | Link |
|--------|--------------|------|
| Complete Guide to Running LLMs on Android with MediaPipe | MLBoy | [Medium](https://rockyshikoku.medium.com/running-llm-on-android-devices-complete-guide-with-mediapipe-on-device-inference-957daa537f52) |
| Guide to Building Smarter Android Apps with Gemini Nano | Nine Pages Of My Life | [Medium](https://medium.com/@niranjanky14/guide-to-building-smarter-android-apps-with-gemini-nano-6b29ee7daecc) |
| How to Deploy LLMs on Android with TensorFlow Lite | HackerNoon | [Article](https://hackernoon.com/how-to-deploy-large-language-models-on-android-with-tensorflow-lite) |
| How I Ran a Local LLM on My Android Phone | Vivek Parashar | [Medium](https://vivekparasharr.medium.com/how-i-ran-a-local-llm-on-my-android-phone-and-what-i-learned-about-googles-ai-edge-gallery-807572211562) |
| llama.cpp Android Tutorial | JackZeng | [GitHub](https://github.com/JackZeng0208/llama.cpp-android-tutorial) |
| How to compile LLM on Android using llama.cpp | mmonteirojs | [Medium](https://medium.com/@mmonteirojs/how-to-compile-any-llm-on-android-using-llama-cpp-46885569768d) |
| Running Llama 3.2 on Android with Ollama | Kamal Kishor | [Dev.to](https://dev.to/koolkamalkishor/running-llama-32-on-android-a-step-by-step-guide-using-ollama-54ig) |

### Cross-platform

| Titolo | Autore/Fonte | Link |
|--------|--------------|------|
| LLM Inference on Edge with React Native | Hugging Face | [Blog](https://huggingface.co/blog/llm-inference-on-edge) |
| Run Gemma and VLMs on mobile with llama.cpp | Georgios Soloupis | [Medium](https://farmaker47.medium.com/run-gemma-and-vlms-on-mobile-with-llama-cpp-dbb6e1b19a93) |
| Deploying SLM on Edge Device: Practical Guide | 4Geeks | [Blog](https://blog.4geeks.io/deploying-a-small-language-model-slm-on-an-edge-device-a-practical-guide/) |

### Quantizzazione

| Titolo | Autore/Fonte | Link |
|--------|--------------|------|
| AI Model Quantization 2025: Master Compression Techniques | Local AI Zone | [Guide](https://local-ai-zone.github.io/guides/what-is-ai-quantization-q4-k-m-q8-gguf-guide-2025.html) |
| Practical Quantization Guide for iPhone and Mac (GGUF) | Enclave AI | [Blog](https://enclaveai.app/blog/2025/11/12/practical-quantization-guide-iphone-mac-gguf/) |
| Understanding GGUF Format: A Comprehensive Guide | Vimal Kansal | [Medium](https://medium.com/@vimalkansal/understanding-the-gguf-format-a-comprehensive-guide-67de48848256) |
| Understanding LLM Weight Quantization: GPTQ, AWQ, GGUF | Abhishek Kumar | [Medium](https://medium.com/@abhi-84/understanding-llm-weight-quantization-gptq-awq-and-gguf-make-big-models-fit-in-a-small-space-518bb204cae4) |
| LLAMA.CPP Guide for Creating GGUFs | Wasif Mehmood | [Medium](https://medium.com/@wasifmehmood/llama-cpp-guide-for-creating-ggufs-ec380568e8fb) |
| GGUF Optimization: A Technical Deep Dive | Michael Hannecke | [Medium](https://medium.com/@michael.hannecke/gguf-optimization-a-technical-deep-dive-for-practitioners-ce84c8987944) |
| The Complete Guide to LLM Quantization | LocalLLM.in | [Blog](https://localllm.in/blog/quantization-explained) |

---

## 4. Articoli Medium e Substack

### On-Device LLM - Concetti generali

| Titolo | Autore | Link |
|--------|--------|------|
| On-Device LLM | Jimin Lee | [Medium](https://medium.com/@jiminlee-ai/on-device-llm-1ea0476a2df6) |
| On-Device LLMs Are Finally Becoming Practical — What Engineers Need to Know in 2025 | Mann Nada | [Medium](https://medium.com/@mannnada05/on-device-llms-are-finally-becoming-practical-heres-what-engineers-need-to-know-in-2025-7cc24d544e25) |
| Building AI-Powered Mobile Apps: Running On-Device LLMs in Android and Flutter (2025 Guide) | Stepan Plotytsia | [Medium](https://medium.com/@stepan_plotytsia/building-ai-powered-mobile-apps-running-on-device-llms-in-android-and-flutter-2025-guide-0b440c0ae08b) |
| Building LLM-Powered Mobile Apps: A Practical Guide for Founders and Product Teams in 2025 | Treena Dutta | [Medium](https://medium.com/@treena95d/building-llm-powered-mobile-apps-a-practical-guide-for-founders-and-product-teams-in-2025-78225227100a) |
| Finally. I know how to run Small Language Models on Mobile phones... for free! | Fabio Matricardi | [Substack](https://substack.com/home/post/p-150743500) |
| Are Local LLMs on Mobile a Gimmick? The Reality in 2025 | Callstack | [Blog](https://www.callstack.com/blog/local-llms-on-mobile-are-a-gimmick) |

### Apple / iOS specifici

| Titolo | Autore | Link |
|--------|--------|------|
| Getting Hands-On with Apple's Foundation Models Framework | Alessio Rubicini | [Medium](https://alessiorubicini.medium.com/getting-hands-on-with-apples-foundation-models-framework-2bebc059db06) |
| Implement Local LLMs on iOS with MLX | Adrián Ramírez | [Medium](https://medium.com/@ale058791/build-an-on-device-ai-text-generator-for-ios-with-mlx-fdd2bea1f410) |
| How to integrate a Large Language Model into an iOS Application | Nguyen Hai Nam | [Medium](https://medium.com/@namcuong2711/how-to-integrate-a-large-language-model-into-an-ios-application-2579d9d119b0) |
| How to Run a Local LLM (e.g., LLaMA 3) on iOS | Shahinoor Shahin | [Medium](https://medium.com/@shahin.cse.sust/how-to-run-a-local-llm-e-g-llama-3-on-ios-b5a16b4e4a1c) |
| Building an AI ChatBot with Apple's Foundation Models Framework | JC | [Medium](https://medium.com/@jc_builds/building-an-ai-chatbot-with-apples-foundation-models-framework-a-complete-swiftui-guide-de0347c0b18b) |
| Exploring the Foundation Models framework | Create with Swift | [Blog](https://www.createwithswift.com/exploring-the-foundation-models-framework/) |
| Getting Started with Apple Foundation Models for Local AI in SwiftUI | Ottorino Bruni | [Blog](https://www.ottorinobruni.com/getting-started-with-apple-foundation-models-for-local-ai-in-swiftui/) |
| Apple Foundation Models Tutorial iOS 26 | iPhone Developers | [Blog](https://www.iphonedevelopers.co.uk/2025/07/apple-foundation-models-ios-tutorial.html) |

### Android specifici

| Titolo | Autore | Link |
|--------|--------|------|
| AI Building Blocks for Android: ML Kit, TensorFlow Lite, and LLM APIs | Manu Misra | [Medium](https://medium.com/@manu706/ai-building-blocks-for-android-ml-kit-tensorflow-lite-and-llm-apis-what-android-devs-need-to-277b9236d32f) |
| Integrate Gemini with Jetpack Compose — the quick way! | Developer Chunk | [Medium](https://medium.com/@developerchunk/integrate-gemini-with-jetpack-compose-the-quick-way-5f5069cb23f0) |
| Building a Gemini API Sample in Jetpack Compose with Room and Koin | Brilian Ade Putra | [Medium](https://medium.com/@brilianadeputra/building-a-gemini-api-sample-in-jetpack-compose-with-room-and-koin-a-complete-guide-59b3dfbc8697) |
| Android App Architecture Patterns 2025: Building Scalable Apps with Hilt, Navigation, and ViewModel | Android Lab | [Medium](https://medium.com/@androidlab/android-app-architecture-patterns-2025-building-scalable-apps-with-hilt-navigation-and-viewmodel-29d2f588d1eb) |

### Architetture e Pattern con AI

| Titolo | Autore | Link |
|--------|--------|------|
| Inside FoundationModels: How Sessions Actually Work | Luiz Fernando Salvaterra | [Medium](https://medium.com/@luizfernandosalvaterra/inside-foundationmodels-how-sessions-actually-work-1a250bb30110) |
| LLM Context Management: How to Improve Performance and Lower Costs | 16x Engineer | [Blog](https://eval.16x.engineer/blog/llm-context-management-guide) |
| The Art of LLM Context Management: Optimizing AI Agents for App Development | Ravi Khurana | [Medium](https://medium.com/@ravikhurana_38440/the-art-of-llm-context-management-optimizing-ai-agents-for-app-development-e5ef9fcf8f75) |
| LLM Context Engineering: a practical guide | Zheng Bruce Li | [Medium](https://medium.com/the-low-end-disruptor/llm-context-engineering-a-practical-guide-248095d4bf71) |
| The Ultimate Guide to LLM Memory: From Context Windows to Advanced Agent Memory Systems | Tanishk Soni | [Medium](https://medium.com/@sonitanishk2003/the-ultimate-guide-to-llm-memory-from-context-windows-to-advanced-agent-memory-systems-3ec106d2a345) |
| Integrating LLMs in Mobile Apps: Challenges & Best Practices (2025 Guide) | The Useful Apps | [Article](https://www.theusefulapps.com/news/integrating-llms-mobile-challenges-best-practices-2025) |
| Hilt vs. Koin: A 2025 Perspective on Android DI | Jamshidbek Boynazarov | [Medium](https://jamshidbekboynazarov.medium.com/hilt-vs-koin-a-2025-perspective-on-android-di-139b27d684e1) |
| The Ultimate Guide to Modern iOS Architecture in 2025 | Max | [Medium](https://medium.com/@csmax/the-ultimate-guide-to-modern-ios-architecture-in-2025-9f0d5fdc892f) |

### Function Calling e Agenti

| Titolo | Autore | Link |
|--------|--------|------|
| On-Device Function Calling with FunctionGemma | Sasha Denisov | [Medium](https://medium.com/google-developer-experts/on-device-function-calling-with-functiongemma-39f7407e5d83) |
| Fine-Tuning Gemma 3 1B for Function Calling: A Step-by-Step Guide | Luca Massaron | [Medium](https://medium.com/@lucamassaron/fine-tuning-gemma-3-1b-for-function-calling-a-step-by-step-guide-66a613352f99) |
| ReAct agents vs function calling agents | AI Teacher | [Medium](https://medium.com/@aiteacher/react-agents-vs-function-calling-agents-ee50f5248d4e) |
| Building ReAct Agents from Scratch: A Hands-On Guide using Gemini | Arun Shankar | [Medium](https://medium.com/google-cloud/building-react-agents-from-scratch-a-hands-on-guide-using-gemini-ffe4621d90ae) |
| A Super Simple ReAct Agent from Scratch | Sami Maameri | [Medium](https://medium.com/data-science-collective/a-super-simple-react-agent-87913949f69f) |
| Implementing ReAct Agentic Pattern From Scratch | Daily Dose of DS | [Article](https://www.dailydoseofds.com/ai-agents-crash-course-part-10-with-implementation/) |

---

## 5. Repository GitHub

### Awesome Lists

| Repository | Descrizione | Stars |
|------------|-------------|-------|
| [awesome-mobile-llm](https://github.com/stevelaskaridis/awesome-mobile-llm) | Lista curata di LLM per mobile ed embedded | ⭐ Top |
| [Awesome-On-Device-AI-Systems](https://github.com/jeho-lee/Awesome-On-Device-AI) | Sistemi AI on-device efficienti | ⭐ |
| [Awesome-Efficient-LLM](https://github.com/horseee/Awesome-Efficient-LLM) | LLM efficienti e tecniche di compressione | ⭐ |
| [Awesome-LLM](https://github.com/Hannibal046/Awesome-LLM) | Lista generale su LLM (23k+ stars) | ⭐⭐⭐ |
| [awesome-llm-apps](https://github.com/Shubhamsaboo/awesome-llm-apps) | App LLM con agenti e RAG | ⭐⭐ |
| [Awesome-LLM-Quantization](https://github.com/pprp/Awesome-LLM-Quantization) | Tecniche di quantizzazione LLM | ⭐ |
| [Awesome-LLM-Inference](https://github.com/xlite-dev/Awesome-LLM-Inference) | Paper su inference LLM | ⭐ |
| [Awesome-Multimodal-LLM](https://github.com/BradyFU/Awesome-Multimodal-Large-Language-Models) | LLM multimodali | ⭐⭐ |
| [Awesome-LLMs-on-device](https://github.com/NexaAI/Awesome-LLMs-on-device) | LLM on-device (MIT licensed) | ⭐ |

### Framework e SDK - Apple/iOS

| Repository | Descrizione |
|------------|-------------|
| [ml-explore/mlx-swift](https://github.com/ml-explore/mlx-swift) | API Swift per MLX (ufficiale Apple) |
| [ml-explore/mlx-swift-examples](https://github.com/ml-explore/mlx-swift-examples) | Esempi MLX Swift: LLMEval, MLXChatExample, VLMEval |
| [preternatural-explore/mlx-swift-chat](https://github.com/preternatural-explore/mlx-swift-chat) | App SwiftUI per LLM locali con MLX |
| [tattn/LocalLLMClient](https://github.com/tattn/LocalLLMClient) | Swift package per LLM locali (GGUF + MLX) |
| [john-rocky/CoreML-Models](https://github.com/john-rocky/CoreML-Models) | Zoo di modelli convertiti in CoreML |

### Framework e SDK - Android/Google

| Repository | Descrizione |
|------------|-------------|
| [google-ai-edge/gallery](https://github.com/google-ai-edge/gallery) | Google AI Edge Gallery app |
| [google-gemini/gemma-cookbook](https://github.com/google-gemini/gemma-cookbook) | Cookbook ufficiale Gemma con notebook |
| [google/generative-ai-docs](https://github.com/google/generative-ai-docs) | Documentazione e tutorial Google GenAI |
| [tirthajyoti-ghosh/expo-llm-mediapipe](https://github.com/tirthajyoti-ghosh/expo-llm-mediapipe) | LLM on-device con Expo e MediaPipe |

### Inference engines

| Repository | Descrizione |
|------------|-------------|
| [ggerganov/llama.cpp](https://github.com/ggerganov/llama.cpp) | Inference LLM in C/C++ (standard de facto) |
| [JackZeng0208/llama.cpp-android-tutorial](https://github.com/JackZeng0208/llama.cpp-android-tutorial) | Tutorial llama.cpp su Android |
| [Mozilla-Ocho/llamafile](https://github.com/Mozilla-Ocho/llamafile) | LLM come singolo eseguibile |
| [MLC-AI/mlc-llm](https://github.com/mlc-ai/mlc-llm) | Deploy universale LLM su qualsiasi hardware |
| [pytorch/executorch](https://github.com/pytorch/executorch) | PyTorch per on-device inference |

### Agenti e function calling

| Repository | Descrizione |
|------------|-------------|
| [pguso/ai-agents-from-scratch](https://github.com/pguso/ai-agents-from-scratch) | Tutorial: costruire agenti AI da zero |
| [arjunprabhulal/adk-gemma3-function-calling](https://github.com/arjunprabhulal/adk-gemma3-function-calling) | Function calling con Gemma 3 e ADK |
| [MobileLLM](https://github.com/MobileLLM) | Organizzazione GitHub per LLM mobile |

### Tool e utilità

| Repository | Descrizione |
|------------|-------------|
| [huggingface/exporters](https://github.com/huggingface/exporters) | Conversione modelli per Core ML |
| [coreml-projects/transformers-to-coreml](https://huggingface.co/spaces/coreml-projects/transformers-to-coreml) | Tool no-code per conversione Core ML |
| [Llamatik](https://github.com/nicosResworker/llamatik) | llama.cpp per Kotlin Multiplatform |

---

## 6. Paper accademici

### Survey e overview

| Titolo | Anno | Link |
|--------|------|------|
| On-Device Language Models: A Comprehensive Review | 2024 | [arXiv](https://arxiv.org/html/2409.00088v1) |
| Mobile Edge Intelligence for Large Language Models: A Contemporary Survey | 2025 | [arXiv](https://arxiv.org/abs/2407.18921) |

### Inference e ottimizzazione

| Titolo | Anno | Link |
|--------|------|------|
| HeteroInfer: Heterogeneous LLM Inference on Mobile SoCs | 2025 | [arXiv](https://arxiv.org/abs/2501.14794) |
| Challenging GPU Dominance: When CPUs Outperform for On-Device LLM Inference | 2025 | [arXiv](https://arxiv.org/abs/2505.06461) |
| Fast On-device LLM Inference with NPUs | 2024 | [arXiv](https://arxiv.org/html/2407.05858v2) |
| Understanding Large Language Models in Your Pockets | 2025 | [arXiv](https://arxiv.org/html/2410.03613v3) |
| Are We There Yet? Efficiency for LLM Applications on Mobile Devices | 2025 | [arXiv](https://arxiv.org/html/2504.00002v1) |

### Modelli specifici

| Titolo | Anno | Link |
|--------|------|------|
| Apple Intelligence Foundation Language Models Tech Report 2025 | 2025 | [arXiv](https://arxiv.org/abs/2507.13575) |
| Optimizing LLMs Using Quantization for Mobile Execution | 2025 | [arXiv](https://arxiv.org/html/2512.06490v1) |
| On-Device Large Language Models for Sequential Recommendation | 2026 | [arXiv](https://arxiv.org/html/2601.09306) |

### Fine-tuning on-device

| Titolo | Anno | Link |
|--------|------|------|
| Memory-Efficient LLM Fine-Tuning on Mobile Device via Server Assisted Side Tuning | 2025 | [ACM](https://dl.acm.org/doi/10.1145/3737902.3768351) |

---

## 7. Cookbook e notebook

### Google Gemma Cookbook

| Notebook | Descrizione | Link |
|----------|-------------|------|
| FunctionGemma Fine-tuning | Fine-tune FunctionGemma per Mobile Actions | [GitHub](https://github.com/google-gemini/gemma-cookbook/blob/main/FunctionGemma/%5BFunctionGemma%5DFinetune_FunctionGemma_270M_for_Mobile_Actions_with_Hugging_Face.ipynb) |
| Full Function Calling Sequence | Workflow completo function calling | [GitHub](https://github.com/google/generative-ai-docs/blob/main/site/en/gemma/docs/functiongemma/full-function-calling-sequence-with-functiongemma.ipynb) |

### Unsloth

| Notebook | Descrizione | Link |
|----------|-------------|------|
| FunctionGemma Fine-tuning | Due notebook per full fine-tuning e LoRA | [Docs](https://docs.unsloth.ai/models/functiongemma) |

### MLX Examples

| Esempio | Descrizione | Link |
|---------|-------------|------|
| LLMEval | App iOS/macOS per valutazione LLM | [GitHub](https://github.com/ml-explore/mlx-swift-examples/blob/main/Applications/LLMEval/README.md) |
| llm-tool | Tool CLI per inference LLM | [GitHub](https://github.com/ml-explore/mlx-swift-examples/blob/main/Tools/llm-tool/README.md) |

---

## 8. Tool e framework

### Inference engines

| Tool | Piattaforme | Descrizione |
|------|-------------|-------------|
| [llama.cpp](https://github.com/ggerganov/llama.cpp) | Cross-platform | Standard de facto per inference LLM in C/C++ |
| [MLC LLM](https://github.com/mlc-ai/mlc-llm) | Cross-platform | Deploy universale basato su TVM |
| [ExecuTorch](https://github.com/pytorch/executorch) | Mobile/Edge | PyTorch per on-device inference |
| [MediaPipe](https://ai.google.dev/edge/mediapipe/solutions/genai/llm_inference) | Android/iOS/Web | Framework Google per ML on-device |
| [LiteRT (ex TFLite)](https://www.tensorflow.org/lite) | Android/iOS | Runtime ML di Google |
| [Core ML](https://developer.apple.com/documentation/coreml) | Apple | Framework ML nativo Apple |
| [MLX](https://github.com/ml-explore/mlx) | Apple Silicon | Framework ML per Apple Silicon |

### Conversione e quantizzazione

| Tool | Descrizione |
|------|-------------|
| [coremltools](https://github.com/apple/coremltools) | Conversione modelli in Core ML |
| [Hugging Face exporters](https://github.com/huggingface/exporters) | Conversione per Core ML |
| [AI Edge Torch](https://ai.google.dev/edge) | Conversione modelli per MediaPipe |
| [llama-quantize](https://github.com/ggerganov/llama.cpp) | Quantizzazione GGUF |

### App di test

| App | Piattaforme | Descrizione |
|-----|-------------|-------------|
| [Google AI Edge Gallery](https://github.com/google-ai-edge/gallery) | Android/iOS | App sperimentale per testare modelli |
| [Ollama](https://ollama.com) | Desktop/Android (Termux) | Gestione e esecuzione LLM locali |
| [LM Studio](https://lmstudio.ai) | Desktop | UI per LLM locali |

---

## 9. Community e blog

### Blog ufficiali

| Blog | Descrizione |
|------|-------------|
| [Android Developers Blog](https://android-developers.googleblog.com/) | Annunci ufficiali Android |
| [Google Developers Blog](https://developers.googleblog.com/) | News da Google |
| [Apple Machine Learning Research](https://machinelearning.apple.com/) | Ricerca ML Apple |
| [Hugging Face Blog](https://huggingface.co/blog) | Tutorial e annunci HF |

### News e analisi

| Sito | Descrizione |
|------|-------------|
| [InfoQ - AI/ML](https://www.infoq.com/ai-ml-data-eng/) | News su AI/ML enterprise |
| [WWDC Notes](https://wwdcnotes.com/) | Note non ufficiali WWDC |
| [Sebastian Raschka's Magazine](https://magazine.sebastianraschka.com/) | Newsletter LLM research |

### Community

| Community | Descrizione |
|-----------|-------------|
| [r/LocalLLaMA](https://reddit.com/r/LocalLLaMA) | Subreddit per LLM locali |
| [Hugging Face Forums](https://discuss.huggingface.co/) | Forum ufficiale HF |
| [Apple Developer Forums](https://developer.apple.com/forums/) | Forum sviluppatori Apple |

---

## Come contribuire

Se conosci risorse utili non incluse in questa lista, sentiti libero di aprire una issue o una pull request!

### Criteri per l'inclusione

- ✅ Contenuto tecnico di qualità
- ✅ Rilevante per on-device AI/LLM mobile
- ✅ Aggiornato (preferibilmente 2024-2026)
- ✅ Link funzionante

---

*Ultimo aggiornamento: Gennaio 2026*
