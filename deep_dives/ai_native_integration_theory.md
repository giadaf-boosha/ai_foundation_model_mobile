# Foundation Models e Sviluppo Nativo Mobile: Guida Teorica

> Una spiegazione narrativa e concettuale di come i modelli AI on-device si integrano con i componenti primitivi dello sviluppo mobile nativo.

---

## Indice

1. [Introduzione: Un Nuovo Paradigma di Sviluppo](#1-introduzione-un-nuovo-paradigma-di-sviluppo)
2. [Il Ruolo del Modello nell'Architettura dell'App](#2-il-ruolo-del-modello-nellarchitettura-dellapp)
3. [La Sessione: Cuore dell'Interazione con l'AI](#3-la-sessione-cuore-dellinterazione-con-lai)
4. [Gestione del Contesto: La Memoria del Modello](#4-gestione-del-contesto-la-memoria-del-modello)
5. [Il Flusso dei Dati: Dall'Input dell'Utente alla Risposta](#5-il-flusso-dei-dati-dallinput-dellutente-alla-risposta)
6. [Streaming: L'Arte di Mostrare Risposte Progressive](#6-streaming-larte-di-mostrare-risposte-progressive)
7. [Persistenza: Salvare le Conversazioni](#7-persistenza-salvare-le-conversazioni)
8. [Tool Calling: Quando il Modello Agisce nel Mondo Reale](#8-tool-calling-quando-il-modello-agisce-nel-mondo-reale)
9. [Gestione degli Errori: Prepararsi all'Imprevisto](#9-gestione-degli-errori-prepararsi-allimprevisto)
10. [Considerazioni di Design per Sviluppatori](#10-considerazioni-di-design-per-sviluppatori)

---

## 1. Introduzione: Un Nuovo Paradigma di Sviluppo

L'introduzione dei foundation model on-device rappresenta un cambiamento fondamentale nel modo in cui pensiamo alle applicazioni mobili. Per la prima volta, gli sviluppatori possono integrare capacità di intelligenza artificiale generativa direttamente nelle loro app senza dipendere da connessioni di rete o servizi cloud.

Tuttavia, questa nuova possibilità porta con sé una domanda cruciale: **dove si colloca esattamente il modello AI all'interno dell'architettura di un'applicazione mobile?**

La risposta non è banale. Un modello linguistico non è semplicemente un'altra API da chiamare o un database da interrogare. È un componente con caratteristiche uniche: mantiene stato (la conversazione), richiede risorse significative (memoria e CPU/NPU), e produce output in modo progressivo (streaming di token). Queste peculiarità richiedono un ripensamento di come strutturiamo le nostre applicazioni.

### La Filosofia delle Due Piattaforme

Apple e Google hanno adottato approcci filosoficamente diversi all'integrazione dell'AI on-device, e queste differenze si riflettono profondamente nel modo in cui gli sviluppatori devono strutturare le loro applicazioni.

**Apple** ha scelto la via dell'integrazione verticale. Il Foundation Models Framework fornisce accesso a un unico modello, quello che alimenta Apple Intelligence, attraverso un'API Swift elegante e type-safe. Non c'è scelta del modello, non c'è configurazione dell'inference engine. Lo sviluppatore riceve un'astrazione pulita che nasconde tutta la complessità sottostante. Questo approccio semplifica enormemente lo sviluppo ma limita la flessibilità.

**Google**, al contrario, ha optato per un ecosistema modulare. Gli sviluppatori possono scegliere tra Gemini Nano (integrato nel sistema operativo), modelli Gemma (open source), o qualsiasi altro modello compatibile con MediaPipe. Questa flessibilità comporta maggiore complessità: bisogna gestire il download dei modelli, scegliere il formato di quantizzazione appropriato, configurare l'inference engine. Il trade-off è chiaro: più controllo in cambio di più responsabilità.

---

## 2. Il Ruolo del Modello nell'Architettura dell'App

### Il Dibattito Eterno: MVC, MVVM, Clean Architecture

Gli sviluppatori mobile hanno familiarità con i pattern architetturali classici. Model-View-Controller (MVC) separa i dati dalla presentazione e dalla logica di controllo. Model-View-ViewModel (MVVM) introduce un intermediario che prepara i dati per la visualizzazione. Clean Architecture aggiunge ulteriori layer di astrazione con Use Case e Repository.

L'arrivo dei foundation model non invalida questi pattern, ma richiede di ripensare dove collocare questo nuovo componente.

### Il Modello AI Non È un Database

Un errore comune è trattare il modello AI come si tratterebbe un database o un'API REST. Si potrebbe pensare: "mando una query, ricevo una risposta, fine". Ma questa analogia è fuorviante per diversi motivi.

**Primo**, il modello mantiene stato. Una conversazione non è una sequenza di richieste indipendenti: ogni messaggio successivo deve essere interpretato nel contesto di quelli precedenti. Se l'utente chiede "Quali sono i migliori ristoranti italiani?" e poi "E quelli giapponesi?", il modello deve capire che il secondo messaggio si riferisce ancora a ristoranti, non a qualcos'altro di giapponese.

**Secondo**, il modello produce output progressivamente. Non restituisce una risposta completa istantaneamente, ma genera token uno alla volta. Questo richiede un pattern di comunicazione diverso: invece di una semplice chiamata sincrona, abbiamo uno stream di dati.

**Terzo**, il modello può fallire in modi peculiari. Oltre agli errori tecnici standard, può esaurire il contesto disponibile, può produrre output malformati, può "allucinare" informazioni false. La gestione degli errori deve tenere conto di queste possibilità uniche.

### Dove Collocare la Sessione AI

Data questa complessità, dove dovrebbe vivere la sessione AI nell'architettura dell'applicazione?

La risposta più comune è: **nel ViewModel** (per MVVM) o nel **Repository** (per Clean Architecture).

Il ViewModel è una scelta naturale perché già gestisce lo stato dell'interfaccia utente e coordina le operazioni asincrone. La sessione AI diventa parte dello stato che il ViewModel espone alla View. Quando l'utente invia un messaggio, il ViewModel inoltra la richiesta alla sessione, riceve lo stream di token, e aggiorna lo stato dell'UI progressivamente.

In architetture più complesse, ha senso isolare l'interazione con l'AI in un Repository dedicato. Questo Repository diventa il Single Source of Truth per tutto ciò che riguarda l'AI: gestisce la sessione, mantiene la storia delle conversazioni, si occupa della persistenza. Il ViewModel interagisce con questo Repository senza conoscere i dettagli implementativi del modello sottostante.

### L'Importanza dell'Astrazione

Qualunque sia l'architettura scelta, è fondamentale creare un'astrazione adeguata attorno al modello AI. Le ragioni sono molteplici.

**Testabilità**: avvolgendo l'interazione AI in un'interfaccia astratta, diventa possibile sostituirla con mock durante i test. Si possono simulare risposte predefinite, errori, o comportamenti edge-case senza dover effettivamente eseguire inference sul modello.

**Flessibilità futura**: le API dei foundation model sono ancora in evoluzione. Apple e Google le aggiornano frequentemente. Avere un layer di astrazione permette di adattarsi ai cambiamenti senza dover modificare il codice in tutta l'applicazione.

**Portabilità**: se l'applicazione deve supportare sia iOS che Android, un'astrazione comune permette di condividere la logica di business pur utilizzando implementazioni platform-specific.

---

## 3. La Sessione: Cuore dell'Interazione con l'AI

### Cos'è una Sessione

Nel contesto dei foundation model on-device, una "sessione" rappresenta un contesto di conversazione isolato. È l'equivalente di una chat aperta con un assistente: tutto ciò che viene detto all'interno di quella sessione contribuisce al contesto condiviso.

Su iOS, Apple fornisce l'oggetto `LanguageModelSession`. Su Android, il concetto è meno esplicito: lo sviluppatore deve gestire manualmente il contesto della conversazione, costruendo prompt che includono la storia dei messaggi precedenti.

### Ciclo di Vita della Sessione

Una sessione nasce quando l'utente inizia una nuova conversazione. Da quel momento, accumula progressivamente informazioni: i prompt dell'utente, le risposte del modello, le istruzioni di sistema. Questo accumulo continua finché la sessione non viene distrutta o finché il contesto non si esaurisce.

Il ciclo di vita tipico è:

1. **Creazione**: l'applicazione crea una nuova sessione, opzionalmente fornendo istruzioni di sistema che definiscono il comportamento del modello
2. **Utilizzo**: l'utente invia messaggi, il modello risponde, il contesto si arricchisce
3. **Persistenza** (opzionale): l'applicazione salva lo stato della conversazione per permettere all'utente di riprendere successivamente
4. **Distruzione**: la sessione viene terminata, liberando le risorse associate

### Sessioni Single-Turn vs Multi-Turn

Non tutte le interazioni con un modello linguistico richiedono il mantenimento del contesto. Esistono due modalità fondamentali:

**Single-turn**: ogni richiesta è indipendente. L'applicazione crea una nuova sessione per ogni operazione, la usa per una singola generazione, e la distrugge. Questo è appropriato per compiti isolati come la sintesi di un documento, la traduzione di una frase, o la classificazione di un contenuto. Non c'è bisogno di "ricordare" interazioni precedenti.

**Multi-turn**: la conversazione si sviluppa nel tempo. L'utente e il modello si scambiano messaggi, ciascuno costruendo su ciò che è stato detto prima. Questo è il modello tipico di un chatbot o di un assistente personale. La sessione deve essere mantenuta per tutta la durata della conversazione.

La scelta tra queste modalità ha implicazioni importanti sulla gestione delle risorse. Le sessioni multi-turn consumano più memoria (devono mantenere la storia) e possono incontrare limiti di contesto più rapidamente.

### Il Problema della Concorrenza

Un aspetto critico delle sessioni AI è che generalmente non supportano richieste concorrenti. Se l'utente invia un nuovo messaggio mentre il modello sta ancora generando una risposta, il comportamento può essere imprevedibile: alcune implementazioni accodano la richiesta, altre la rifiutano con un errore, altre ancora interrompono la generazione in corso.

L'applicazione deve gestire questo scenario esplicitamente. L'approccio più comune è disabilitare l'input dell'utente durante la generazione, mostrando un indicatore di attività. Un'alternativa è permettere l'invio ma accodare le richieste internamente, processandole in sequenza.

---

## 4. Gestione del Contesto: La Memoria del Modello

### La Finestra di Contesto

I modelli linguistici hanno una "memoria" limitata chiamata finestra di contesto (context window). Questa finestra definisce quanti token il modello può considerare simultaneamente durante la generazione. Tutto ciò che cade fuori da questa finestra viene effettivamente "dimenticato".

Per i modelli on-device, le finestre di contesto sono relativamente piccole rispetto ai loro equivalenti cloud. Il modello di Apple supporta circa 4.096 token. Gemini Nano e Gemma variano, ma raramente superano gli 8.192 token. A confronto, i modelli cloud come GPT-4 possono gestire 128.000 token o più.

### Cosa Consuma il Contesto

Il contesto viene consumato da diversi elementi:

**Istruzioni di sistema**: le indicazioni iniziali che definiscono il comportamento del modello ("Sei un assistente culinario esperto...") occupano spazio che rimane fisso per tutta la durata della sessione.

**Storia della conversazione**: ogni messaggio dell'utente e ogni risposta del modello vengono memorizzati nel contesto. Più lunga è la conversazione, più spazio viene consumato.

**Prompt corrente**: la richiesta attuale dell'utente occupa spazio.

**Risposta in generazione**: il modello deve riservare spazio anche per la risposta che sta generando.

### Strategie di Gestione del Contesto

Quando una conversazione rischia di superare la finestra di contesto, l'applicazione deve adottare strategie per rimanere entro i limiti.

**Sliding window**: la strategia più semplice è mantenere solo gli ultimi N messaggi, eliminando i più vecchi man mano che ne arrivano di nuovi. Questo funziona bene per conversazioni leggere ma può causare la perdita di informazioni importanti condivise all'inizio della chat.

**Summarization**: un approccio più sofisticato consiste nel riassumere periodicamente la conversazione passata. Invece di mantenere tutti i messaggi verbatim, si chiede al modello stesso di produrre un riassunto condensato. Questo riassunto diventa il nuovo "inizio" della sessione, preservando le informazioni chiave in forma compressa.

**Context pruning intelligente**: alcune implementazioni avanzate analizzano quali parti della conversazione sono effettivamente rilevanti per il messaggio corrente, eliminando selettivamente i contenuti meno pertinenti. Questo richiede una logica aggiuntiva ma può essere molto efficace.

**Nuova sessione con contesto**: quando il contesto si esaurisce, si può creare una nuova sessione inizializzandola con un riassunto della conversazione precedente. L'utente non percepisce l'interruzione, ma tecnicamente si tratta di una sessione fresca.

### Monitorare l'Utilizzo del Contesto

Le applicazioni ben progettate monitorano attivamente l'utilizzo del contesto. Questo può tradursi in indicatori visuali per l'utente ("La conversazione sta diventando lunga, potresti voler iniziare una nuova chat") o in azioni automatiche quando si avvicina il limite.

Stimare l'utilizzo del contesto richiede una comprensione della tokenizzazione. Un token non equivale a una parola: generalmente, una parola inglese comune corrisponde a 1-2 token, mentre parole rare o termini tecnici possono richiederne di più. Una stima approssimativa è che un carattere corrisponda a circa 0.25 token, ma questa è solo un'euristica.

---

## 5. Il Flusso dei Dati: Dall'Input dell'Utente alla Risposta

### Anatomia di una Richiesta

Quando l'utente invia un messaggio a un'applicazione con AI integrata, si innesca una catena di eventi che attraversa tutti i layer dell'architettura.

**Layer UI**: l'utente digita un messaggio e preme invio. La View cattura questo input e lo passa al ViewModel (o equivalente).

**Layer di Presentazione**: il ViewModel riceve l'input, lo valida, aggiorna lo stato dell'UI per mostrare che una richiesta è in corso (indicatore di caricamento, disabilitazione dell'input), e delega l'operazione al layer sottostante.

**Layer di Dominio/Dati**: il Repository (o Use Case) riceve la richiesta, interagisce con la sessione AI, e inizia a ricevere la risposta. Durante la generazione, le risposte parziali vengono propagate verso l'alto attraverso i layer.

**Ritorno alla UI**: ogni frammento di risposta ricevuto causa un aggiornamento dello stato nel ViewModel, che a sua volta causa un re-render della View con il nuovo contenuto.

### Unidirectional Data Flow

Il pattern di "flusso di dati unidirezionale" si adatta perfettamente all'integrazione AI. Lo stato fluisce in una sola direzione (dal modello dati alla UI), mentre gli eventi fluiscono nella direzione opposta (dalla UI alle azioni).

In questo modello:
- L'utente genera eventi (invia messaggio, cancella conversazione, riprova)
- Gli eventi vengono processati e causano modifiche allo stato
- Le modifiche allo stato causano aggiornamenti automatici della UI
- La UI non modifica mai direttamente lo stato, ma solo attraverso eventi

Questo pattern è particolarmente importante con l'AI perché le risposte sono asincrone e progressive. Avere un flusso di dati chiaro e prevedibile semplifica enormemente il debugging e previene stati inconsistenti.

### Reattività e Osservabilità

Sia SwiftUI che Jetpack Compose sono framework dichiarativi e reattivi. La UI viene descritta come funzione dello stato: quando lo stato cambia, la UI si aggiorna automaticamente.

Su iOS, il macro `@Observable` (introdotto con iOS 17) permette di creare oggetti il cui stato viene automaticamente osservato dalle View SwiftUI. Qualsiasi modifica a una proprietà di un oggetto `@Observable` causa il re-render delle View che la utilizzano.

Su Android, `StateFlow` e `Flow` sono i meccanismi principali per esporre stato reattivo. Le Composable function osservano questi flussi e si ricompongono quando emettono nuovi valori.

Questa reattività è fondamentale per lo streaming delle risposte AI: ogni nuovo token ricevuto modifica lo stato, e la UI si aggiorna di conseguenza, creando l'effetto di "digitazione" tipico dei chatbot.

---

## 6. Streaming: L'Arte di Mostrare Risposte Progressive

### Perché Lo Streaming È Importante

Immaginate di chiedere a un assistente AI di scrivere un paragrafo. Senza streaming, l'utente vedrebbe uno spinner di caricamento per diversi secondi, seguito dalla comparsa improvvisa dell'intero testo. Con lo streaming, le parole appaiono progressivamente, come se l'assistente stesse effettivamente digitando.

La differenza in termini di esperienza utente è drammatica. Lo streaming riduce la latenza percepita: l'utente inizia a leggere immediatamente invece di aspettare. Fornisce inoltre feedback continuo: l'utente vede che qualcosa sta accadendo, riducendo l'incertezza e la frustrazione.

### Come Funziona Tecnicamente

I modelli linguistici generano testo un token alla volta. Durante l'inferenza, il modello predice il prossimo token basandosi sui token precedenti (sia quelli del prompt che quelli già generati). Questo processo si ripete finché non viene raggiunto un token di fine sequenza o un limite massimo.

Lo streaming espone questo processo incrementale all'applicazione. Invece di attendere il completamento dell'intera generazione, l'applicazione riceve notifiche ad ogni nuovo token (o gruppo di token) prodotto.

### Snapshot vs Delta

Esistono due approcci principali per comunicare le risposte parziali:

**Delta streaming**: ogni notifica contiene solo i nuovi token generati. L'applicazione deve concatenarli per costruire la risposta completa. Questo è l'approccio tradizionale, usato dalla maggior parte delle API cloud.

**Snapshot streaming**: ogni notifica contiene l'intera risposta parziale fino a quel punto. L'applicazione sostituisce semplicemente il contenuto precedente con il nuovo snapshot. Questo è l'approccio adottato da Apple nel Foundation Models Framework.

Lo snapshot streaming ha vantaggi in contesti dichiarativi: non richiede logica di concatenazione, e si integra naturalmente con il binding dello stato delle UI moderne. Tuttavia, trasmette più dati ridondanti.

### Output Strutturato e Streaming

Un caso particolarmente interessante è lo streaming di output strutturato. Quando il modello genera un oggetto con campi multipli (nome, descrizione, lista di elementi...), i campi vengono popolati progressivamente.

Apple ha introdotto il concetto di "PartiallyGenerated" per gestire questo scenario. Quando si richiede un output strutturato in streaming, ogni snapshot contiene un oggetto dove alcuni campi sono già popolati e altri sono ancora nulli. L'ordine di popolamento segue l'ordine di dichiarazione dei campi nel tipo.

Questo permette pattern UI sofisticati: ad esempio, mostrare il titolo di una ricetta appena disponibile, poi gli ingredienti mentre vengono generati, infine i passaggi. L'interfaccia si popola progressivamente invece di apparire tutta insieme.

### Considerazioni di UI Design

Lo streaming richiede attenzione nel design dell'interfaccia:

**Scroll automatico**: mentre il testo viene generato, la vista dovrebbe scorrere automaticamente per mantenere visibile il nuovo contenuto. Ma questo deve essere bilanciato: se l'utente ha scrollato manualmente verso l'alto per rileggere qualcosa, l'autoscroll potrebbe essere fastidioso.

**Indicatori di stato**: l'utente dovrebbe capire chiaramente che la generazione è in corso. Un cursore lampeggiante, un'animazione, o un indicatore esplicito comunicano che il modello sta ancora lavorando.

**Gestione delle animazioni**: le transizioni tra stati dovrebbero essere fluide. SwiftUI e Compose offrono primitive di animazione che possono essere usate per rendere l'apparizione del testo più naturale.

**Identità delle view**: nei framework dichiarativi, è importante gestire correttamente l'identità delle view durante lo streaming, specialmente quando si generano liste. Un'identità instabile può causare animazioni strane o perdita di stato.

---

## 7. Persistenza: Salvare le Conversazioni

### Perché Persistere

Molte applicazioni AI beneficiano dalla capacità di salvare e riprendere conversazioni. Un utente potrebbe voler continuare una discussione iniziata giorni prima, o riferirsi a informazioni scambiate in una sessione precedente.

La persistenza serve anche scopi tecnici: se l'applicazione viene terminata dal sistema operativo per liberare memoria, l'utente non dovrebbe perdere la conversazione in corso.

### Cosa Salvare

La persistenza di una conversazione AI richiede di salvare diversi elementi:

**Messaggi**: il contenuto testuale scambiato tra utente e modello, con metadati come timestamp e ruolo (utente/assistente).

**Metadati della conversazione**: titolo, data di creazione, ultimo aggiornamento, eventuali tag o categorie.

**Stato della sessione** (opzionale): alcune implementazioni permettono di serializzare l'intero stato della sessione AI, incluso il contesto interno. Questo permette di riprendere esattamente dove si era interrotto, senza dover ricostruire il contesto dai messaggi.

### Tecnologie di Persistenza

Su iOS, le opzioni principali sono:

**SwiftData**: il nuovo framework di Apple per la persistenza, costruito sopra Core Data ma con un'API Swift-native. Utilizza macro per definire i modelli e si integra perfettamente con SwiftUI attraverso proprietà wrapper come `@Query`.

**Core Data**: il framework tradizionale, più verboso ma ancora pienamente supportato. Offre funzionalità avanzate come la sincronizzazione iCloud tramite CloudKit.

**File system**: per casi semplici, serializzare le conversazioni in JSON e salvarle come file può essere sufficiente.

Su Android, le opzioni includono:

**Room**: il layer di astrazione sopra SQLite raccomandato da Google. Usa annotazioni per definire entità e DAO, e si integra con Kotlin Coroutines e Flow per operazioni asincrone e reattive.

**DataStore**: adatto per dati semplici e preferenze, meno per strutture complesse come conversazioni.

**File system con Serialization**: simile a iOS, JSON o Protocol Buffers possono essere usati per persistenza file-based.

### Pattern di Repository per la Persistenza

Un pattern comune è avere un repository che astrae sia l'interazione con l'AI che la persistenza:

Il repository espone metodi come "ottieni conversazione", "salva messaggio", "cancella conversazione". Internamente, coordina tra la sessione AI (per le operazioni in tempo reale) e il database (per la persistenza). Quando l'utente invia un messaggio, il repository lo salva nel database, lo inoltra alla sessione AI, e quando riceve la risposta, salva anche quella.

Questo approccio centralizza la logica e garantisce coerenza tra lo stato in memoria e quello persistito.

### Sincronizzazione e Conflitti

Per applicazioni che supportano più dispositivi, la sincronizzazione delle conversazioni introduce complessità aggiuntiva.

**iCloud/CloudKit** su iOS e **Firebase/Google Drive** su Android offrono primitive per la sincronizzazione, ma gestire conflitti (modifiche concorrenti sullo stesso dato da dispositivi diversi) richiede logica applicativa.

Per le conversazioni AI, una strategia comune è trattare ogni messaggio come immutabile una volta creato: non si modificano messaggi esistenti, si aggiungono solo nuovi messaggi. Questo elimina la maggior parte dei conflitti.

---

## 8. Tool Calling: Quando il Modello Agisce nel Mondo Reale

### Oltre la Generazione di Testo

I modelli linguistici sono straordinariamente capaci nel manipolare testo, ma le applicazioni reali spesso richiedono di più. Un utente potrebbe chiedere "Che tempo fa a Milano?" o "Aggiungi un evento al calendario per domani alle 15". Queste richieste richiedono l'accesso a dati o servizi esterni che il modello non possiede intrinsecamente.

Il "tool calling" (o "function calling") è il meccanismo che permette al modello di invocare funzioni definite dallo sviluppatore per compiere azioni nel mondo reale.

### Come Funziona Concettualmente

Il processo di tool calling segue tipicamente questo flusso:

1. **Registrazione**: lo sviluppatore definisce uno o più "tool", ciascuno con un nome, una descrizione, e una specifica dei parametri che accetta
2. **Inferenza**: quando l'utente invia una richiesta, il modello la analizza e decide se può rispondere direttamente o se ha bisogno di invocare un tool
3. **Chiamata**: se il modello decide di usare un tool, genera una richiesta strutturata con il nome del tool e i parametri
4. **Esecuzione**: l'applicazione riceve questa richiesta, esegue l'azione corrispondente, e restituisce il risultato al modello
5. **Completamento**: il modello usa il risultato per formulare la risposta finale all'utente

### Definire Tool Efficaci

La qualità del tool calling dipende fortemente da come i tool vengono definiti.

**Nome chiaro**: il nome dovrebbe essere un verbo o una frase che descrive chiaramente l'azione ("cercaRistoranti", "inviaEmail", "ottieniMeteo").

**Descrizione esaustiva**: la descrizione aiuta il modello a capire quando usare il tool. Dovrebbe spiegare cosa fa, in quali situazioni è appropriato, e cosa restituisce.

**Parametri ben tipizzati**: ogni parametro dovrebbe avere un tipo chiaro e, dove possibile, vincoli (range numerici, valori ammessi, regex per stringhe).

**Esempi impliciti**: nelle istruzioni di sistema, includere esempi di quando usare ciascun tool migliora significativamente l'accuratezza.

### Integrazione con API di Sistema

I tool più potenti sono quelli che integrano l'AI con le capacità native del dispositivo:

**Mappe e localizzazione**: cercare luoghi, calcolare percorsi, ottenere la posizione corrente.

**Calendario e promemoria**: creare eventi, leggere appuntamenti, impostare notifiche.

**Contatti**: cercare persone, ottenere informazioni di contatto.

**Salute e fitness**: accedere a dati sanitari (con appropriate autorizzazioni).

**Domotica**: controllare dispositivi smart home.

Queste integrazioni trasformano l'assistente AI da un semplice generatore di testo a un agente capace di compiere azioni concrete.

### Considerazioni di Sicurezza

Il tool calling introduce rischi che devono essere gestiti con attenzione:

**Autorizzazioni**: l'utente deve essere consapevole e acconsentire alle azioni che l'AI può compiere. Non è appropriato che un'app invii email o modifichi il calendario senza conferma esplicita.

**Validazione**: i parametri generati dal modello devono essere validati prima dell'esecuzione. Un modello potrebbe "allucinare" valori non validi o potenzialmente pericolosi.

**Rate limiting**: per tool che interagiscono con servizi esterni, implementare limiti per prevenire abusi accidentali o intenzionali.

**Rollback**: dove possibile, le azioni dovrebbero essere reversibili, o almeno l'utente dovrebbe poter annullare prima della conferma finale.

---

## 9. Gestione degli Errori: Prepararsi all'Imprevisto

### Tipi di Errori nell'AI On-Device

L'integrazione AI introduce categorie di errori specifiche che vanno oltre i classici errori di rete o database:

**Modello non disponibile**: su iOS, Apple Intelligence potrebbe non essere abilitato, o il dispositivo potrebbe non essere compatibile. Su Android, il modello potrebbe non essere ancora scaricato o il dispositivo potrebbe non supportarlo.

**Contesto esaurito**: la conversazione è diventata troppo lunga e il modello non può processare ulteriori messaggi.

**Timeout di generazione**: la generazione sta richiedendo troppo tempo, possibilmente a causa di risorse di sistema limitate.

**Output malformato**: quando si usa output strutturato, il modello potrebbe generare dati che non rispettano lo schema richiesto.

**Errori di tool**: l'esecuzione di un tool può fallire per ragioni proprie (rete non disponibile, permessi negati, servizio esterno in errore).

### Strategie di Recupero

Per ciascun tipo di errore, l'applicazione dovrebbe avere una strategia di recupero:

**Retry con backoff**: per errori transitori, riprovare dopo un breve intervallo, aumentando progressivamente l'attesa tra i tentativi.

**Fallback graceful**: se il modello AI non è disponibile, offrire un'esperienza degradata ma funzionale. Ad esempio, permettere all'utente di usare l'app senza le funzionalità AI.

**Reset della sessione**: per errori di contesto, creare una nuova sessione, opzionalmente preservando un riassunto della conversazione precedente.

**Feedback all'utente**: comunicare chiaramente cosa è andato storto e, se possibile, cosa l'utente può fare. Messaggi come "Abilita Apple Intelligence nelle Impostazioni" sono più utili di generici "Si è verificato un errore".

### Logging e Monitoraggio

Per migliorare l'affidabilità nel tempo, è importante raccogliere dati sugli errori:

**Log strutturati**: registrare tipo di errore, contesto, parametri di input (anonimizzati), e stato dell'applicazione.

**Metriche aggregate**: tracciare tassi di successo/fallimento, tempi di generazione, utilizzo del contesto.

**Crash reporting**: integrare con servizi come Crashlytics o Sentry per catturare errori non gestiti.

Questi dati permettono di identificare pattern problematici e prioritizzare le correzioni.

---

## 10. Considerazioni di Design per Sviluppatori

### Iniziare Semplice

L'integrazione AI può diventare molto complessa, ma è saggio iniziare con l'implementazione più semplice possibile:

- Una singola sessione senza persistenza
- Nessun tool calling, solo generazione di testo
- Gestione degli errori basilare

Una volta che questo funziona, si può iterare aggiungendo feature: persistenza, tool, streaming sofisticato, gestione avanzata del contesto.

### Testare l'Imprevedibile

I modelli linguistici sono intrinsecamente non deterministici. Lo stesso prompt può produrre risposte diverse in esecuzioni successive. Questo rende il testing tradizionale difficile.

Strategie utili includono:

**Mock deterministici**: per test automatizzati, sostituire il modello reale con mock che restituiscono risposte predefinite.

**Test di proprietà**: invece di verificare output esatti, verificare proprietà (la risposta contiene certe informazioni, il JSON è valido, la lunghezza è nel range atteso).

**Test con utenti reali**: nessun testing automatizzato può sostituire l'osservazione di come utenti reali interagiscono con l'AI.

### Performance e Risorse

L'inferenza AI è computazionalmente intensiva. Considerazioni chiave:

**Prewarming**: caricare il modello in memoria prima che l'utente ne abbia bisogno riduce la latenza percepita alla prima richiesta.

**Background processing**: per operazioni lunghe, considerare l'esecuzione in background con notifiche al completamento.

**Thermal throttling**: monitorare la temperatura del dispositivo e ridurre l'attività AI se necessario per prevenire surriscaldamento.

**Battery awareness**: in modalità risparmio energetico, considerare di disabilitare o limitare le funzionalità AI.

### Privacy by Design

L'AI on-device offre vantaggi di privacy rispetto al cloud, ma richiede comunque attenzione:

**Dati sensibili**: evitare di includere informazioni personali nelle istruzioni di sistema o nei prompt inviati a servizi di analytics.

**Persistenza**: se le conversazioni vengono salvate, offrire all'utente controllo su cosa viene conservato e per quanto tempo.

**Trasparenza**: comunicare chiaramente all'utente che l'AI è on-device e che i dati non lasciano il dispositivo.

### Accessibilità

Le funzionalità AI dovrebbero essere accessibili a tutti gli utenti:

**VoiceOver/TalkBack**: assicurarsi che le risposte AI siano correttamente lette dagli screen reader.

**Dynamic Type**: le interfacce chat dovrebbero rispettare le preferenze di dimensione del testo.

**Riduzione del movimento**: le animazioni di streaming dovrebbero rispettare le impostazioni di accessibilità.

---

## Conclusione: Un Nuovo Capitolo nello Sviluppo Mobile

L'integrazione dei foundation model on-device segna l'inizio di un nuovo capitolo nello sviluppo di applicazioni mobili. Per la prima volta, capacità di intelligenza artificiale generativa sofisticata sono disponibili direttamente sul dispositivo dell'utente, senza dipendenze cloud.

Questo apre possibilità straordinarie: assistenti personali che rispettano la privacy, applicazioni che funzionano offline, esperienze con latenza impercettibile. Ma porta anche nuove sfide: gestione del contesto, streaming di risposte, integrazione architettturale, gestione di errori peculiari.

Gli sviluppatori che padroneggiano questi concetti saranno in grado di creare la prossima generazione di applicazioni intelligenti. La chiave è comprendere profondamente come questi modelli funzionano e come si integrano con i pattern architetturali consolidati dello sviluppo mobile.

---

*Per esempi di codice e implementazioni pratiche, vedi [ai_native_integration.md](ai_native_integration.md)*

*Ultimo aggiornamento: Gennaio 2026*
