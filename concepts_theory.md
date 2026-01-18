# Foundation Model On-Device per Dispositivi Mobili
## Guida Teorica ai Concetti Fondamentali - Gennaio 2026

---

## Indice

1. [Introduzione ai foundation model on-device](#1-introduzione-ai-foundation-model-on-device)
2. [Ecosistema Apple](#2-ecosistema-apple)
3. [Ecosistema Google](#3-ecosistema-google)
4. [Parametri di generazione del testo](#4-parametri-di-generazione-del-testo)
5. [Architetture agentiche](#5-architetture-agentiche)
6. [Function calling e tools](#6-function-calling-e-tools)
7. [Quantizzazione e ottimizzazione](#7-quantizzazione-e-ottimizzazione)
8. [Confronto tra piattaforme](#8-confronto-tra-piattaforme)
9. [Glossario](#9-glossario)

---

## 1. Introduzione ai foundation model on-device

### Definizione

Un **foundation model on-device** è un modello di intelligenza artificiale di grandi dimensioni, tipicamente un Large Language Model (LLM), che viene eseguito direttamente sul dispositivo dell'utente finale (smartphone o tablet) anziché su server remoti nel cloud.

Questi modelli sono chiamati "foundation" (fondamentali) perché rappresentano la base su cui costruire applicazioni AI più specifiche. Sono pre-addestrati su enormi quantità di dati testuali e possono essere adattati a compiti diversi senza necessità di riaddestramento completo.

### Vantaggi dell'esecuzione locale

**Privacy dei dati**: quando un modello viene eseguito localmente, i dati dell'utente non lasciano mai il dispositivo. Questo è cruciale per applicazioni che trattano informazioni sensibili come dati sanitari, finanziari o comunicazioni personali. Non esiste alcun rischio di intercettazione durante la trasmissione e nessun server esterno conserva le richieste dell'utente.

**Latenza ridotta**: l'eliminazione del round-trip di rete significa che le risposte sono praticamente istantanee. Non c'è attesa per l'invio della richiesta a un server, l'elaborazione remota e la ricezione della risposta. Questo è particolarmente importante per applicazioni in tempo reale come la traduzione simultanea o gli assistenti vocali.

**Funzionamento offline**: le applicazioni possono funzionare completamente senza connessione internet. Questo le rende utilizzabili in aereo, in zone con scarsa copertura, o semplicemente quando l'utente preferisce non consumare dati mobili.

**Riduzione dei costi**: per gli sviluppatori, non ci sono costi di inference cloud da sostenere per ogni richiesta degli utenti. Una volta distribuita l'applicazione, il costo computazionale ricade sull'hardware dell'utente.

### Sfide tecniche

**Limitazioni di memoria**: gli smartphone hanno RAM limitata rispetto ai server cloud. Un modello che richiede 16 GB di RAM non può funzionare su un telefono con 8 GB. Questo richiede tecniche di compressione aggressive.

**Consumo energetico**: l'esecuzione di modelli AI è computazionalmente intensiva e può drenare rapidamente la batteria. Le implementazioni devono bilanciare qualità delle risposte e consumo energetico.

**Dissipazione termica**: l'elaborazione intensiva genera calore. I telefoni possono surriscaldarsi e attivare il throttling termico, riducendo le prestazioni per proteggere l'hardware.

**Dimensione del modello**: i modelli devono essere distribuiti insieme all'applicazione o scaricati separatamente. Modelli di diversi gigabyte possono essere problematici per lo storage degli utenti.

### Stato dell'arte a gennaio 2026

L'evoluzione hardware ha reso possibile ciò che era impensabile pochi anni fa. I Neural Processing Unit (NPU) moderni raggiungono potenze di calcolo di 70+ TOPS (Trillion Operations Per Second), sufficienti per eseguire modelli con oltre 4 miliardi di parametri a velocità conversazionale.

I benchmark più recenti mostrano prestazioni impressionanti: i dispositivi flagship come iPhone 17 Pro raggiungono circa 136 token al secondo, mentre Galaxy S25 Ultra arriva a 91 token al secondo. Queste velocità permettono conversazioni fluide e naturali.

Le previsioni indicano che modelli da 7 miliardi di parametri diventeranno lo standard per dispositivi di fascia media entro la fine del 2026, mentre i modelli da 13 miliardi saranno eseguibili sui flagship.

---

## 2. Ecosistema Apple

### Foundation Models Framework

Apple ha introdotto il proprio framework per l'AI on-device al WWDC 2025. Si tratta di un sistema integrato verticalmente che fornisce accesso al modello linguistico che alimenta Apple Intelligence, il sistema di intelligenza artificiale personale di Apple.

Il modello on-device di Apple conta circa 3 miliardi di parametri ed è stato specificamente ottimizzato per l'hardware Apple Silicon. A differenza delle soluzioni Android, Apple non permette agli sviluppatori di sostituire questo modello con alternative, garantendo un'esperienza coerente ma limitando la flessibilità.

### Caratteristiche architetturali

**KV-Cache Sharing**: Apple ha sviluppato un'innovazione chiamata condivisione della cache key-value. Il modello è diviso in due blocchi: il primo contiene il 62,5% dei layer transformer, mentre il secondo contiene il restante 37,5%. Il secondo blocco riutilizza la cache key-value generata dal primo, risparmiando il 37,5% della memoria normalmente richiesta per questa struttura dati.

**Quantizzazione a 2-bit**: il modello utilizza una tecnica chiamata "quantization-aware training" a 2 bit. Questo significa che durante l'addestramento il modello ha "imparato" a funzionare bene anche con una rappresentazione numerica estremamente compressa, riducendo drasticamente l'occupazione di memoria.

**Context window fisso**: il modello supporta una finestra di contesto di 4.096 token, senza possibilità di modifica. Questo limite include sia l'input dell'utente che la risposta generata, quindi se l'input occupa 3.000 token, restano solo 1.096 token per la risposta.

### Guided Generation

La "generazione guidata" è la caratteristica distintiva del framework Apple. Permette agli sviluppatori di definire schemi strutturati che il modello deve seguire nell'output, garantendo risposte in formati predefiniti e type-safe.

Invece di ricevere testo libero che deve essere poi analizzato (con rischio di errori), lo sviluppatore definisce la struttura dati desiderata e il modello genera direttamente output conformi a quella struttura. Questo elimina la necessità di parsing manuale e previene le "allucinazioni" strutturali.

### LoRA Adapters

LoRA (Low-Rank Adaptation) è una tecnica che permette di personalizzare il comportamento del modello per casi d'uso specifici senza ritrainarlo completamente.

Il concetto è semplice: invece di modificare tutti i miliardi di parametri del modello, LoRA aggiunge piccole matrici "adapter" che modificano il comportamento solo dove necessario. Nel caso di Apple, questi adapter hanno rank 32 e occupano circa 160 MB ciascuno.

Questo permette, ad esempio, di creare un adapter che rende il modello esperto in terminologia legale, o uno che lo specializza nella scrittura di codice Swift, mantenendo le capacità generali del modello base.

### Piattaforme supportate

Il framework è disponibile su iOS 26+, iPadOS 26+, macOS 26+ e visionOS 26+. I requisiti hardware sono stringenti: è necessario un iPhone con chip A17 Pro o successivo, oppure un iPad o Mac con chip della serie M.

---

## 3. Ecosistema Google

### Panoramica dell'offerta

Google offre un ecosistema più frammentato ma flessibile rispetto ad Apple, con due percorsi principali per l'AI on-device.

**Gemini Nano** è il modello proprietario di Google, integrato nativamente in Android attraverso il sistema AICore. Non è un modello open-source e viene gestito interamente dal sistema operativo, che si occupa del download, degli aggiornamenti e dell'ottimizzazione per l'hardware specifico.

**Gemma** è una famiglia di modelli open-source derivati dalla stessa ricerca che ha prodotto Gemini. Essendo open-source, possono essere utilizzati liberamente, modificati e distribuiti dagli sviluppatori.

### Gemini Nano e AICore

AICore è il sottosistema Android che gestisce i modelli AI di fondazione. Il suo ruolo è fondamentale: si occupa della distribuzione del modello Gemini Nano, gestisce gli aggiornamenti automatici e ottimizza l'esecuzione per l'hardware specifico del dispositivo.

Per gli sviluppatori questo significa non doversi preoccupare della distribuzione di modelli pesanti: AICore scarica e mantiene aggiornato Gemini Nano in background. L'applicazione si limita a chiamare le API e riceve le risposte.

La versione attuale, Gemini Nano v3 (disponibile sui Pixel 10), condivide l'architettura con Gemma 3n, il che significa che le ottimizzazioni sviluppate per uno beneficiano anche l'altro.

### ML Kit GenAI APIs

Google fornisce API a diversi livelli di astrazione attraverso ML Kit:

**API ad alta astrazione**: sono progettate per casi d'uso specifici e richiedono minimo sforzo di integrazione. Includono Summarization (riassunto automatico di testi), Proofreading (correzione grammaticale), Rewriting (riscrittura in stili diversi) e Image Description (descrizione di immagini).

**Prompt API**: è un'API a bassa astrazione che permette di inviare prompt arbitrari in linguaggio naturale. Offre massima flessibilità ma richiede più lavoro di prompt engineering e quality assurance da parte dello sviluppatore.

### Gemma 3n - L'architettura mobile-first

Gemma 3n rappresenta l'evoluzione di Gemma specificamente progettata per dispositivi mobili. È stata sviluppata in collaborazione con i principali produttori di chip mobile: Qualcomm, MediaTek e Samsung.

**Per-Layer Embeddings (PLE)**: questa innovazione di Google DeepMind riduce drasticamente l'uso di RAM. Invece di caricare tutti gli embedding del vocabolario in memoria contemporaneamente, li carica dinamicamente layer per layer. Il risultato è che modelli con 5-8 miliardi di parametri nominali possono funzionare con il footprint di memoria di modelli da 2-3 miliardi.

**Attivazione selettiva dei parametri**: Gemma 3n non utilizza tutti i suoi parametri per ogni inferenza. Attiva selettivamente solo le porzioni del modello necessarie per la specifica richiesta, riducendo ulteriormente i requisiti computazionali.

**Supporto multimodale**: oltre al testo, Gemma 3n può elaborare immagini come input, con supporto audio in arrivo. Questo permette applicazioni come l'analisi di foto o la risposta a domande su contenuti visivi.

### MediaPipe LLM Inference API

Per chi desidera utilizzare modelli Gemma o altri LLM compatibili con massima flessibilità, Google fornisce MediaPipe. È un framework che permette di caricare modelli in formato TFLite o Task Bundle ed eseguirli localmente.

A differenza di ML Kit che usa Gemini Nano gestito dal sistema, con MediaPipe lo sviluppatore ha piena responsabilità: deve scegliere il modello, convertirlo nel formato corretto, includerlo nell'app e gestirne la distribuzione.

### Google AI Edge Gallery

È un'applicazione sperimentale che permette di testare modelli GenAI direttamente su dispositivo. Funziona completamente offline e supporta il "Bring Your Own Model": gli sviluppatori possono caricare i propri modelli in formato LiteRT per testarli.

L'app include diverse funzionalità dimostrative: chat multi-turno, analisi di immagini, trascrizione audio, e metriche di performance in tempo reale come Time To First Token e velocità di decodifica.

---

## 4. Parametri di generazione del testo

### Introduzione ai parametri di sampling

Quando un LLM genera testo, non produce output deterministico. Ad ogni passo, calcola una distribuzione di probabilità su tutto il vocabolario e seleziona il token successivo secondo questa distribuzione. I parametri di sampling controllano come avviene questa selezione.

### Temperature

La temperatura è il parametro più importante e intuitivo. Controlla la "creatività" o "casualità" delle risposte.

Tecnicamente, la temperatura scala i logit (i valori grezzi prima del softmax) dividendoli per il valore di temperatura. Una temperatura alta "appiattisce" la distribuzione, rendendo più probabili anche i token con probabilità originariamente basse. Una temperatura bassa "acutizza" la distribuzione, concentrando la probabilità sui token già favoriti.

**Temperatura 0**: il modello diventa completamente deterministico, scegliendo sempre il token più probabile (modalità "greedy"). Date le stesse condizioni, produrrà sempre lo stesso output.

**Temperatura 0.1-0.3**: risposte molto conservative e prevedibili. Utile per compiti che richiedono precisione come la generazione di codice o risposte fattuali.

**Temperatura 0.5-0.7**: buon bilanciamento tra coerenza e varietà. È il range consigliato per la maggior parte delle applicazioni conversazionali.

**Temperatura 0.8-1.0**: risposte più creative e varie. Utile per scrittura creativa, brainstorming o quando si desidera diversità nelle risposte.

**Temperatura > 1.0**: output sempre più casuale, può diventare incoerente o senza senso. Raramente utile in pratica.

### Top-K Sampling

Top-K limita la selezione ai K token più probabili, azzerando la probabilità di tutti gli altri.

Con K=1, equivale a temperatura 0 (sempre il token più probabile). Con K=40 (valore comune), il modello può scegliere solo tra i 40 token più probabili ad ogni passo.

Questo previene la selezione di token con probabilità molto bassa che potrebbero portare a output strani o incoerenti, pur mantenendo varietà sufficiente.

### Top-P (Nucleus Sampling)

Top-P è un'alternativa più adattiva a Top-K. Invece di fissare il numero di token considerati, seleziona dinamicamente il set minimo di token la cui probabilità cumulativa raggiunge P.

Con P=0.9, il modello considera i token più probabili finché la loro probabilità cumulativa non supera il 90%. Se pochi token concentrano la maggior parte della probabilità, ne verranno considerati pochi. Se la probabilità è distribuita, ne verranno considerati molti.

Questo si adatta naturalmente alla "confidenza" del modello: quando è sicuro considera poche opzioni, quando è incerto ne considera molte.

### Context Window

La finestra di contesto è il numero massimo di token che il modello può "vedere" contemporaneamente. Include tutto: il prompt di sistema, la cronologia della conversazione, l'input corrente e lo spazio per la risposta.

Per Apple Foundation Models è fissato a 4.096 token. Per Gemma 3 il limite teorico è 128.000 token, ma su dispositivi mobili i limiti pratici sono molto inferiori a causa della memoria disponibile.

Gestire il contesto è cruciale nelle applicazioni di chat. Quando la conversazione supera il limite, è necessario implementare strategie come:
- Sliding window: si elimina la cronologia più vecchia
- Riassunto: si riassume la conversazione passata e si usa il riassunto come contesto
- Nuova sessione: si inizia una nuova conversazione

### Seed

Il seed inizializza il generatore di numeri casuali usato nel sampling. Usando lo stesso seed con gli stessi parametri e lo stesso input, si ottiene lo stesso output.

Questo è utile per:
- Debugging: riprodurre esattamente un comportamento problematico
- Testing: verificare che le modifiche non alterino output specifici
- Consistenza: garantire risposte identiche per lo stesso input

### Max Output Tokens

Limita la lunghezza massima della risposta generata. Il modello si ferma quando raggiunge questo limite, anche se la risposta non è completa.

È importante calibrare questo valore: troppo basso tronca risposte utili, troppo alto spreca risorse computazionali e può permettere risposte prolisse.

---

## 5. Architetture agentiche

### Dal chatbot all'agente

Un chatbot tradizionale funziona in modo reattivo: riceve una domanda e fornisce una risposta. Non mantiene memoria significativa, non può eseguire azioni nel mondo reale, non pianifica.

Un agente AI è fondamentalmente diverso: riceve un obiettivo e lavora autonomamente per raggiungerlo. Può pianificare sequenze di azioni, utilizzare strumenti esterni, mantenere memoria delle interazioni passate, e adattare il proprio comportamento in base ai risultati ottenuti.

### Il paradigma ibrido on-device + cloud

L'architettura moderna per agenti mobili è ibrida. Sul dispositivo risiede un Small Language Model (SLM), un modello compatto ottimizzato per compiti specifici:
- Riconoscimento dell'intent dell'utente
- Pianificazione leggera
- Gestione di dati sensibili che non devono lasciare il dispositivo
- Routing: decidere se gestire localmente o escalare al cloud

Un router intelligente valuta ogni richiesta considerando:
- Sensibilità dei dati (dati personali → locale)
- Complessità del compito (ragionamento complesso → cloud)
- Stato del dispositivo (batteria scarica → semplifica o cloud)
- Disponibilità di rete (offline → locale obbligato)

Solo quando necessario, la richiesta viene inoltrata a un LLM completo nel cloud per ragionamento avanzato o generazione estesa.

### Pattern ReAct (Reasoning + Acting)

ReAct è uno dei pattern più influenti per costruire agenti. L'idea centrale è alternare fasi di ragionamento (Thought) con fasi di azione (Action), osservando i risultati (Observation) prima di continuare.

Il ciclo è:
1. THOUGHT: l'agente ragiona su cosa fare per avanzare verso l'obiettivo
2. ACTION: l'agente decide quale strumento usare e con quali parametri
3. OBSERVATION: l'agente riceve il risultato dell'azione
4. Ritorno al punto 1, finché l'obiettivo non è raggiunto

Questo approccio è potente perché il ragionamento esplicito aiuta il modello a evitare errori, e le osservazioni intermedie permettono correzioni di rotta.

### Pattern Planning Agent

Un planning agent opera in due fasi distinte. Prima genera un piano completo: una sequenza di passi necessari per raggiungere l'obiettivo. Poi esegue il piano passo per passo.

Il vantaggio è che il piano può essere rivisto e approvato prima dell'esecuzione. Lo svantaggio è la rigidità: se qualcosa va storto durante l'esecuzione, potrebbe essere necessario ripianificare.

Varianti più sofisticate combinano pianificazione con adattamento dinamico: si pianifica, si inizia l'esecuzione, e si ripianifica se le osservazioni lo richiedono.

### Sistemi multi-agente

In un sistema multi-agente, diversi agenti specializzati collaborano per completare compiti complessi. Ogni agente ha competenze specifiche e un ruolo definito.

Una configurazione tipica include:
- **Orchestrator**: coordina gli altri agenti, decide chi attivare
- **Planner**: specializzato nella scomposizione di obiettivi in sottotask
- **Executor**: specializzato nell'esecuzione di azioni specifiche
- **Critic**: valuta i risultati e suggerisce miglioramenti

La comunicazione tra agenti avviene tipicamente in linguaggio naturale, il che rende il sistema flessibile ma introduce overhead.

### Agenti gerarchici

Negli agenti gerarchici, esiste una gerarchia di comando. Agenti di alto livello prendono decisioni strategiche e delegano a agenti di basso livello l'esecuzione tattica.

Questo rispecchia le organizzazioni umane: un manager definisce gli obiettivi, i team leader li scompongono in task, i singoli contributor li eseguono.

### Memoria negli agenti

Gli agenti efficaci necessitano di memoria strutturata, tipicamente organizzata su tre livelli ispirati ai sistemi operativi:

**Working Memory (L1)**: contesto attivo della sessione corrente. Equivale ai registri della CPU. Contiene le informazioni immediatamente rilevanti per il compito in corso.

**Main Memory (L2)**: cronologia recente delle interazioni. Equivale alla RAM. Mantiene le ultime N interazioni o le interazioni delle ultime ore/giorni.

**Archive (L3)**: storage persistente con retrieval semantico. Equivale al disco. Contiene tutta la storia delle interazioni, recuperabile tramite ricerca semantica quando rilevante.

Il retrieval semantico è cruciale: invece di cercare per parole chiave esatte, si cerca per similarità di significato. Quando l'utente chiede "parlami del progetto di Milano", il sistema recupera interazioni passate semanticamente correlate anche se usavano parole diverse.

---

## 6. Function calling e tools

### Concetto fondamentale

Il function calling (chiamata di funzione) è la capacità di un LLM di generare output strutturati che rappresentano chiamate a funzioni esterne, invece di semplice testo.

Questo trasforma il modello da generatore di testo a orchestratore di azioni. Il modello analizza la richiesta dell'utente, decide quale funzione chiamare, genera i parametri appropriati in formato strutturato (tipicamente JSON), e l'applicazione esegue effettivamente la funzione.

### Flusso tipico

1. L'utente fa una richiesta: "Che tempo fa a Milano?"
2. Il modello riconosce che serve una funzione esterna
3. Il modello genera: `{"function": "get_weather", "args": {"city": "Milano"}}`
4. L'applicazione esegue la funzione `get_weather("Milano")`
5. L'applicazione restituisce il risultato al modello: "15°C, soleggiato"
6. Il modello genera la risposta finale: "A Milano ci sono 15°C con cielo soleggiato"

### Model Context Protocol (MCP)

MCP è un protocollo open-source creato da Anthropic che standardizza come gli LLM si connettono a strumenti e dati esterni. È stato rapidamente adottato come standard de-facto dall'industria.

Prima di MCP, ogni integrazione richiedeva implementazione custom. Con MCP, uno strumento implementato una volta può essere usato da qualsiasi agente compatibile.

L'architettura è client-server: gli MCP Server espongono strumenti e dati, gli MCP Client (agenti) li consumano. La comunicazione avviene tramite JSON-RPC.

### FunctionGemma

FunctionGemma è un modello Google da 270 milioni di parametri, specificamente ottimizzato per function calling on-device. La sua dimensione compatta (288 MB) lo rende eseguibile su qualsiasi smartphone moderno.

Il modello base ha un'accuratezza del 58% sui compiti di function calling. Dopo fine-tuning su casi d'uso specifici, l'accuratezza sale all'85%. Questo lo rende pratico per applicazioni reali dove l'utente richiede azioni come "Crea un promemoria per domani" o "Accendi la torcia".

Il vocabolario di 256k token è ottimizzato per tokenizzare efficientemente JSON e testo multilingue, entrambi cruciali per il function calling.

### Tool definition

Per usare il function calling, è necessario definire i tool disponibili. Una definizione tipica include:
- **Nome**: identificatore univoco della funzione
- **Descrizione**: spiegazione di cosa fa la funzione, usata dal modello per decidere quando invocarla
- **Parametri**: schema dei parametri accettati, con tipi, descrizioni e vincoli

La qualità delle descrizioni è cruciale: il modello decide quale funzione chiamare basandosi sulle descrizioni in linguaggio naturale.

### Chiamate parallele e seriali

I framework moderni gestiscono automaticamente grafi di chiamate complessi. Se una richiesta richiede più funzioni indipendenti, possono essere eseguite in parallelo. Se una funzione dipende dal risultato di un'altra, vengono eseguite in serie.

Ad esempio, "Cerca voli per Roma domani e hotel vicino al Colosseo" potrebbe generare due chiamate parallele a search_flights e search_hotels. Ma "Prenota il volo più economico e poi un hotel" richiede prima trovare il volo, poi prenotare l'hotel per le date corrette.

### Sicurezza e validazione

Il function calling introduce rischi di sicurezza. Il modello potrebbe generare chiamate con parametri malevoli o inattesi. È essenziale:
- Validare tutti i parametri prima dell'esecuzione
- Implementare sandboxing per funzioni potenzialmente pericolose
- Richiedere conferma utente per azioni irreversibili
- Mantenere log dettagliati delle chiamate

---

## 7. Quantizzazione e ottimizzazione

### Il problema della dimensione

I modelli linguistici moderni hanno miliardi di parametri. Ogni parametro è tipicamente rappresentato come numero in virgola mobile a 32 bit (FP32), occupando 4 byte. Un modello da 3 miliardi di parametri richiede quindi 12 GB solo per i pesi, senza contare le strutture dati di supporto come il KV-cache.

Questo è problematico per dispositivi mobili con RAM limitata. La quantizzazione risolve questo problema.

### Cos'è la quantizzazione

La quantizzazione riduce la precisione numerica usata per rappresentare i pesi del modello. Invece di usare numeri in virgola mobile a 32 bit, si usano rappresentazioni più compatte:

**FP16 (16 bit)**: dimezza la dimensione mantenendo il 99% circa della qualità. È il primo passo di compressione, spesso usato anche in training.

**INT8 (8 bit)**: riduce a un quarto la dimensione originale. La qualità scende al 97% circa, ma per molti casi d'uso è accettabile.

**INT4 (4 bit)**: riduce a un ottavo la dimensione. Un modello da 12 GB diventa 1.5 GB. La qualità scende al 94% circa, ma tecniche avanzate minimizzano la perdita.

**INT2 (2 bit)**: compressione estrema a 1/16. La perdita di qualità è significativa (intorno all'85%) e questo livello è sconsigliato per la maggior parte delle applicazioni.

### Tecniche di quantizzazione

**Post-Training Quantization (PTQ)**: quantizza il modello dopo l'addestramento, senza necessità di ritrainare. È veloce e semplice ma può introdurre degradazione della qualità, specialmente a bassi bit.

**Quantization-Aware Training (QAT)**: durante l'addestramento, il modello "simula" gli effetti della quantizzazione e impara a compensarli. Produce risultati migliori ma richiede risorse significative per il ritraining.

Apple usa QAT a 2-bit per il suo modello on-device, raggiungendo qualità sorprendente nonostante la compressione aggressiva.

### Formato GGUF

GGUF (GPT-Generated Unified Format) è diventato lo standard per distribuzione di LLM su hardware consumer. Definisce vari livelli di quantizzazione:

**Q4_K_M** (4-bit medium): il default consigliato. Buon bilanciamento tra dimensione e qualità.

**Q5_K_M** (5-bit medium): per applicazioni che richiedono qualità superiore.

**Q8_0** (8-bit): massima qualità quantizzata, quando lo spazio non è un problema.

**Q2_K** (2-bit): solo per esperimenti, qualità troppo degradata per uso pratico.

### Ottimizzazioni runtime

Oltre alla quantizzazione dei pesi, esistono ottimizzazioni per l'esecuzione:

**Operator Fusion**: combina operazioni consecutive (es. MatMul + Add + ReLU) in un'unica operazione ottimizzata. Riduce accessi memoria e overhead di chiamata.

**KV-Cache**: durante la generazione, memorizza i vettori Key e Value già calcolati per non ricalcolarli ad ogni nuovo token. Fondamentale per velocità di generazione.

**Speculative Decoding**: un modello piccolo e veloce (draft) genera candidati, il modello principale li valida in batch. Se corretti, si accettano tutti insieme. Può raddoppiare o triplicare la velocità.

**Per-Layer Embeddings**: innovazione di Gemma 3n. Invece di caricare tutto il vocabolario in memoria, carica gli embedding dinamicamente per layer. Permette modelli nominalmente più grandi con footprint effettivo ridotto.

### Considerazioni pratiche

La scelta del livello di quantizzazione dipende dall'hardware target e dai requisiti di qualità:

| RAM disponibile | Modello consigliato |
|-----------------|---------------------|
| 4 GB | 1-2B parametri in INT4 |
| 6 GB | 3B parametri in INT4 |
| 8 GB | 7B parametri in INT4 |
| 12 GB | 13B parametri in INT4 |

La velocità dipende anche dall'NPU. Con 15+ TOPS ci si aspetta 50-80 token/secondo per modelli 3B. Con 45+ TOPS si può arrivare a 100+ token/secondo.

---

## 8. Confronto tra piattaforme

### Filosofie divergenti

Apple e Google hanno approcci fondamentalmente diversi all'AI on-device, riflettendo le loro filosofie generali.

**Apple** privilegia l'integrazione verticale. Fornisce un singolo modello ottimizzato per il proprio hardware, non sostituibile. Lo sviluppatore ha meno controllo ma anche meno responsabilità: Apple gestisce tutto, dalla distribuzione agli aggiornamenti.

**Google** privilegia la flessibilità. Offre sia soluzioni gestite (Gemini Nano via AICore) che completamente open (Gemma via MediaPipe). Lo sviluppatore può scegliere il livello di controllo desiderato.

### Hardware AI

**Apple Neural Engine**: presente in tutti i chip A-series e M-series, è un NPU progettato specificamente per machine learning. I chip recenti (A17 Pro, M4) raggiungono 35-40+ TOPS. L'integrazione stretta con il software Apple permette ottimizzazioni impossibili su hardware third-party.

**Android NPU**: il panorama è frammentato. Qualcomm Hexagon, MediaTek APU, Samsung NPU e Google TPU (nei Pixel) hanno tutti caratteristiche diverse. Snapdragon 8 Gen 3 raggiunge 45 TOPS, Gen 4 65+, e Gen 5 (2026) promette 100+. Questa frammentazione richiede ottimizzazioni per device.

### Stack software

**iOS**:
- Foundation Models Framework: alto livello, accesso al modello Apple
- Core ML: medio livello, per modelli custom
- MLX: basso livello, per ricerca e sperimentazione
- Metal: molto basso livello, GPU compute diretto

**Android**:
- ML Kit GenAI: alto livello, accesso a Gemini Nano
- MediaPipe: medio livello, per modelli Gemma e custom
- TensorFlow Lite: medio livello, per modelli TF
- NNAPI: basso livello, hardware acceleration

### Facilità di sviluppo

Su iOS, il Foundation Models Framework offre un'esperienza molto fluida. Le API Swift sono eleganti, la guided generation elimina il parsing manuale, il tool calling è automatico. La complessità è bassa, ma la flessibilità anche.

Su Android, ML Kit GenAI è altrettanto semplice per i casi d'uso standard. MediaPipe richiede più lavoro ma offre controllo completo sulla scelta del modello, la sua distribuzione e configurazione.

### Privacy

Entrambe le piattaforme mantengono i dati on-device quando si usano modelli locali. Apple ha un vantaggio percettivo dato il suo marketing incentrato sulla privacy, ma tecnicamente Google offre le stesse garanzie per Gemini Nano e modelli locali.

La differenza sta nel default: Apple spinge fortemente verso on-device, Google offre anche opzioni cloud che possono essere più facili da implementare.

### Dispositivi supportati

Apple limita l'AI on-device a dispositivi recenti: iPhone con A17 Pro o successivo, iPad e Mac con chip M. Questo esclude una parte significativa della base installata.

Google supporta un range più ampio grazie alla varietà di modelli e livelli di quantizzazione. Anche dispositivi mid-range con 6+ GB di RAM possono eseguire modelli base.

### Quando scegliere cosa

**Scegli iOS Foundation Models quando**:
- Sviluppi solo per iOS
- Vuoi massima semplicità di integrazione
- Il modello Apple soddisfa i tuoi requisiti
- Non hai bisogno di personalizzazioni profonde

**Scegli MLX + Core ML quando**:
- Sviluppi per iOS ma hai bisogno di modelli custom
- Fai ricerca o sperimentazione
- Hai requisiti specifici non coperti dal modello Apple

**Scegli ML Kit GenAI quando**:
- Sviluppi per Android
- I casi d'uso standard (summarization, rewriting, etc.) sono sufficienti
- Vuoi che Google gestisca distribuzione e aggiornamenti del modello

**Scegli MediaPipe LLM quando**:
- Sviluppi per Android e hai bisogno di massima flessibilità
- Vuoi usare modelli Gemma o altri modelli custom
- Hai bisogno di LoRA adapters o fine-tuning
- Vuoi controllo completo sulla distribuzione

**Scegli soluzioni cross-platform (Cactus, llama.cpp) quando**:
- Sviluppi per entrambe le piattaforme
- Vuoi lo stesso modello su iOS e Android
- Hai requisiti molto specifici non coperti dalle soluzioni native

---

## 9. Glossario

**AICore**: sottosistema Android che gestisce i modelli AI di fondazione, incluso Gemini Nano.

**Context window**: numero massimo di token che un modello può elaborare contemporaneamente.

**Fine-tuning**: processo di specializzazione di un modello pre-addestrato per un compito specifico.

**Foundation model**: modello AI di grandi dimensioni pre-addestrato su dati vasti, usato come base per applicazioni specifiche.

**Function calling**: capacità di un LLM di generare chiamate strutturate a funzioni esterne.

**GGUF**: formato file standard per distribuzione di LLM quantizzati.

**Guided generation**: tecnica che vincola l'output del modello a schemi strutturati predefiniti.

**Inference**: processo di generazione di output da un modello addestrato.

**KV-cache**: struttura dati che memorizza i vettori Key e Value calcolati durante la generazione per evitare ricalcoli.

**LLM (Large Language Model)**: modello linguistico di grandi dimensioni addestrato su enormi corpora di testo.

**LoRA (Low-Rank Adaptation)**: tecnica di fine-tuning efficiente che aggiunge piccoli adapter ai pesi del modello.

**MCP (Model Context Protocol)**: protocollo standard per connettere LLM a strumenti e dati esterni.

**ML Kit**: SDK Google per machine learning su Android.

**MLX**: framework Apple per machine learning su Apple Silicon.

**NPU (Neural Processing Unit)**: processore specializzato per operazioni di machine learning.

**On-device**: esecuzione locale sul dispositivo dell'utente, senza invio dati al cloud.

**Prompt**: input testuale fornito a un LLM per generare una risposta.

**PTQ (Post-Training Quantization)**: quantizzazione applicata dopo l'addestramento.

**QAT (Quantization-Aware Training)**: addestramento che simula gli effetti della quantizzazione.

**Quantizzazione**: riduzione della precisione numerica per comprimere i modelli.

**ReAct**: pattern agentico che alterna ragionamento e azione.

**Sampling**: processo di selezione del prossimo token durante la generazione.

**SLM (Small Language Model)**: modello linguistico compatto, ottimizzato per dispositivi con risorse limitate.

**Speculative decoding**: tecnica che usa un modello piccolo per generare candidati validati dal modello principale.

**Temperature**: parametro che controlla la casualità nella generazione del testo.

**Token**: unità base di testo elaborata dal modello (tipicamente parole, sottoparole o caratteri).

**Tool use**: sinonimo di function calling.

**Top-K**: parametro che limita la selezione ai K token più probabili.

**Top-P**: parametro che seleziona token finché la probabilità cumulativa raggiunge P.

**TOPS (Trillion Operations Per Second)**: misura della potenza di calcolo degli NPU.

---

## Riferimenti

### Documentazione Apple
- Apple Developer Documentation: Foundation Models Framework
- WWDC25: Meet the Foundation Models Framework
- WWDC25: Deep dive into the Foundation Models Framework
- Apple Machine Learning Research: Foundation Models 2025 Updates
- Tech Note TN3193: Managing the Context Window

### Documentazione Google
- Android Developers: ML Kit GenAI APIs
- Google AI for Developers: MediaPipe LLM Inference
- Google AI for Developers: Gemma Mobile Deployment
- Google Developers Blog: Introducing Gemma 3n
- Google Blog: FunctionGemma

### Ricerca accademica
- Apple Intelligence Foundation Language Models Tech Report 2025
- Optimizing LLMs Using Quantization for Mobile Execution
- Large Language Model Performance Benchmarking on Mobile Platforms

### Risorse comunitarie
- Awesome Mobile LLM (GitHub)
- llama.cpp (GitHub)
- Google AI Edge Gallery (GitHub)

---

*Report teorico - Gennaio 2026*
