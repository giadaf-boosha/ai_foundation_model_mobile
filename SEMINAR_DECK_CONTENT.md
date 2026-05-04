# Seminar Deck Content — Foundation Models On-Device su iOS e Android

> **Artefatto intermedio per generazione deck Claude Design.**
> **Sede**: Universita di Bologna · **Docente referente**: Prof. Federico Montori
> **Relatrice**: Giada Franceschini · **Durata**: 120 minuti · **Slide totali**: 60
> **Lingua**: italiano (titoli + body), termini tecnici inglese · **Versione**: 1.0 — 4 maggio 2026

Questo documento contiene il contenuto integrale di ogni singola slide del deck del seminario:
testo completo, codice, tabelle, descrizioni visual con sorgente suggerita, speaker notes (~2 min/slide)
e riferimenti puntuali a file del repo e URL verificati.

E' pensato come **input per la skill `prompt-design-deck`**, che genera il prompt copy-paste per
[claude.ai/design](https://claude.ai/design). Non e' il prompt finale — e' il contenuto da impacchettare.

## Indice e distribuzione temporale

| Blocco | Slide | Min | Topic |
|--------|-------|----:|-------|
| 0 — Apertura | 0-3 | 5 | Cover, chi sono, agenda, hook |
| 1 — Fondamenti on-device | 4-11 | 17 | Definizione, perche, vantaggi/limiti, decision tree, hardware NPU, energia, roadmap |
| 2 — Apple ecosystem | 12-21 | 20 | Stack, modello, LanguageModelSession, @Generable, Tool, iOS 26.4, MLX/M5, LoRA, PCC, WWDC26 |
| 3 — Google ecosystem | 22-29 | 16 | Stack Android, Nano history, Gemma 4, MatFormer/PLE, ML Kit, LiteRT-LM, FunctionGemma, AICore Preview |
| 4 — Agenti + MCP | 30-36 | 14 | ReAct/Plan/Mobile-Agent-v2, memoria 4-tipologie, pattern offline, GUI agents, MCP, MCP mobile |
| 5 — Quantizzazione + Bench | 37-42 | 12 | Panorama, PTQ vs QAT, BitNet, NanoQuant, MLPerf v6.0, throughput reali |
| 6 — Hands-on demo live | 43-50 | 16 | Setup, Swift x3 + backup, Kotlin x2 + backup |
| 7 — Chiusura | 51-59 | 20 | Decision matrix, anti-pattern, numeri, esercizi, futuro, take-away, risorse, domande, Q&A |

**Note di lettura**:
- Ogni slide ha la struttura: Headline → Sottotitolo → Body (max 40 parole sulla slide) → Tabella/Codice (se presente) → Visual (descrizione + sorgente) → Speaker notes (~150-200 parole) → Riferimenti.
- I marker `[DA VERIFICARE]` indicano punti dove la fonte non era esplicitamente verificata in `SOTA_2026.md` o nei file letti — vanno controllati prima della live.
- Le slide demo (44-50) hanno una sezione `### Backup` aggiuntiva con output atteso e screenshot da pre-catturare.

---

# Blocco 0 — Apertura (slide 0-3)

## Slide 0 — Cover
**Timing**: 0:00-1:00
**Tipo**: cover

### Headline
Foundation Models On-Device su iOS e Android

### Sottotitolo
Lo stato dell'arte ad aprile 2026 — Apple FM Framework, Google Gemma 4, hardware NPU e quantizzazione

### Body
Universita di Bologna · Prof. Federico Montori · Maggio 2026
Giada Franceschini — Boosha AI

### Visual
- **Descrizione**: composizione visiva tre elementi affiancati: silhouette iPhone con icona Apple Intelligence, silhouette Pixel con logo Gemma, sotto un chip NPU stilizzato. Sfondo gradient scuro (notte) con accenti #2ed6b1.
- **Sorgente suggerita**: diagramma da generare, brand colors Boosha (primary #116f5f, accent #2ed6b1), logo UniBO in basso a sinistra.

### Speaker notes
Buongiorno a tutti, grazie al Prof. Montori per l'invito. Nelle prossime due ore vi mostrero qualcosa che fino a tre anni fa la maggior parte di noi avrebbe considerato fantascienza: far girare modelli linguistici da miliardi di parametri direttamente sul telefono che avete in tasca, senza cloud, senza connessione, e senza spendere un centesimo di inferenza. Ad aprile 2026 questa non e' piu' una promessa: e' un'API stabile, GA, su iOS 26 e su Android 14+. Oggi guardiamo i due ecosistemi dominanti — Apple Foundation Models Framework e Google Gemma 4 con AICore — confrontiamo modelli, hardware e pattern di integrazione. Avremo anche una demo live in Swift e Kotlin. Il ritmo sara' serrato, circa 60 slide in 120 minuti: tenete pronte le domande per la sessione Q&A finale, oppure interrompetemi se qualcosa non e' chiaro nei momenti di codice.

### Riferimenti
- File repo: /Users/giadafranceschini/code/ai_foundation_model_mobile/SEMINAR.md
- File repo: /Users/giadafranceschini/code/ai_foundation_model_mobile/README.md

---

## Slide 1 — Chi sono
**Timing**: 1:00-2:30
**Tipo**: text

### Headline
Chi sono

### Sottotitolo
Giada Franceschini — Boosha AI

### Body
- Co-founder Boosha AI: assessment e implementazione AI in PMI italiane
- Background: sviluppo mobile + integrazione AI generativa in flussi di lavoro reali
- Repo del seminario: github.com/giadaf-boosha/ai_foundation_model_mobile (`SOTA_2026.md`, `concepts_theory.md`, esempi Swift/Kotlin)

### Visual
- **Descrizione**: foto profilo a sinistra (cerchio), a destra tre badge orizzontali: "Boosha AI", "Mobile + GenAI", "Repo aperto". Sotto QR code che porta al repo GitHub.
- **Sorgente suggerita**: foto fornita da Giada, QR generato da https://github.com/giadaf-boosha/ai_foundation_model_mobile

### Speaker notes
Due parole su di me: sono co-founder di Boosha AI, ci occupiamo di assessment e implementazione di soluzioni AI per PMI italiane — quindi vivo ogni giorno il gap tra la promessa dei modelli frontier nel cloud e i vincoli reali di privacy, costo e latenza che le aziende incontrano. L'on-device e' una delle leve piu' interessanti per chiudere quel gap, ed e' il motivo per cui ho costruito il repository che vedete in basso, `ai_foundation_model_mobile`. E' pubblico, in italiano, contiene la teoria, gli esempi di codice Swift e Kotlin che useremo nella demo, e soprattutto un file `SOTA_2026.md` che ho aggiornato il 29 aprile, dieci giorni fa, con tutto quello che e' uscito tra Gemma 4, AICore Developer Preview, iOS 26.4 e MLPerf v6.0. Tutto cio' che diro' oggi e' verificabile li': i link delle slide puntano sempre a fonti primarie.

### Riferimenti
- https://github.com/giadaf-boosha/ai_foundation_model_mobile
- File repo: /Users/giadafranceschini/code/ai_foundation_model_mobile/README.md

---

## Slide 2 — Agenda visiva
**Timing**: 2:30-4:00
**Tipo**: diagram

### Headline
Le 2 ore in 12 sezioni

### Sottotitolo
Speech + tabelle + demo live (Swift e Kotlin)

### Tabella
| Slot | Min | Topic |
|------|-----|-------|
| 0 | 5 | Apertura, contesto, motivazioni |
| 1 | 10 | Perche' on-device — vantaggi e limiti |
| 2 | 15 | Apple Foundation Models Framework |
| 3 | 15 | Google Gemma 4 / Gemini Nano 4 / LiteRT-LM |
| 4 | 10 | Hardware: A19 Pro, M5, Tensor G5, Snapdragon 8 Elite Gen 5 |
| 5 | 15 | Quantizzazione: GGUF, BitNet 1.58, NanoQuant |
| 6 | 15 | **Demo live** Swift + Kotlin |
| 7 | 10 | Function calling / Tool protocol / FunctionGemma |
| 8 | 5 | MCP: stato e prospettive mobile |
| 9 | 5 | Benchmark MLPerf v6.0 |
| 10 | 10 | Q&A |
| 11 | 5 | Risorse e take-away |

### Visual
- **Descrizione**: timeline orizzontale a barre proporzionali ai minuti, colori gradient da #116f5f a #2ed6b1. Marcatore evidenziato sulla sezione corrente (slot 0). Icona "demo live" (play) sullo slot 6.
- **Sorgente suggerita**: diagramma da generare a partire dalla tabella in SEMINAR.md sezione 4.

### Speaker notes
Questa e' la mappa delle prossime due ore. Vi do due ancore: la **Demo live** e' allo slot 6, intorno al minuto 75 — e' il momento in cui passiamo dalla teoria al codice che gira davvero su iPhone e Pixel; e il **Q&A** allo slot 10, ultimi dieci minuti. La struttura segue una logica precisa: prima motiviamo perche' on-device adesso ha senso, poi entriamo nei due ecosistemi in parallelo, poi guardiamo l'hardware che li abilita e la quantizzazione che e' il vero ingrediente segreto, e infine vediamo il futuro — agenti, MCP, benchmark. Ho previsto cinque minuti di buffer cumulativo distribuiti tra demo e Q&A: se qualcosa va storto durante la demo abbiamo un video di backup pronto. La regola del seminario e' una sola: interrompete se qualcosa non e' chiaro, soprattutto durante il codice.

### Riferimenti
- File repo: /Users/giadafranceschini/code/ai_foundation_model_mobile/SEMINAR.md (sezione 4)

---

## Slide 3 — Una frase
**Timing**: 4:00-6:00
**Tipo**: text

### Headline
L'AI e' arrivata sul telefono

### Sottotitolo
Non in laboratorio. Sul telefono che avete adesso in tasca.

### Body
- iPhone 17 Pro (A19 Pro): **136 token/s** con framework Cactus su modello ~3B
- BitNet b1.58 2B su CPU ARM M2: **~45 tok/s** in CPU-only, **0.4 GB di RAM**
- Gemini Nano 4 Fast: **3x piu' veloce** della generazione precedente, **-60% batteria**

### Visual
- **Descrizione**: tre cifre giganti centrate verticalmente, una sotto l'altra: "136 tok/s", "0.4 GB RAM", "-60% batteria". Sotto ogni cifra una riga di contesto piccola. Sfondo nero, cifre in #2ed6b1.
- **Sorgente suggerita**: tipografia tipo Inter Bold 200pt; valori da SOTA_2026.md tabella sezione 10.2 e sezione 3.2.

### Speaker notes
Voglio darvi tre numeri da tenere a mente per le prossime due ore. Centotrentasei token al secondo: e' la velocita' di generazione misurata su iPhone 17 Pro con il framework Cactus su un modello di circa tre miliardi di parametri — fonte Argmax, settembre 2025. Per riferimento, la lettura ad alta voce e' circa cinque token al secondo: stiamo parlando di venticinque volte piu' veloce di quanto un essere umano possa leggere. Secondo numero: zero virgola quattro gigabyte di RAM. E' quello che serve a BitNet b1.58, un modello da due miliardi di parametri quantizzato a 1.58 bit nativi, per girare su uno smartphone con quattro giga di RAM totali, senza offloading. Terzo numero: meno sessanta percento di batteria. E' il delta dichiarato da Google per Gemini Nano 4 rispetto alla versione precedente. Insieme questi tre numeri raccontano una storia: l'on-device non e' piu' un compromesso, e' una scelta architetturale legittima.

### Riferimenti
- https://www.argmaxinc.com/blog/iphone-17-on-device-inference-benchmarks
- https://arxiv.org/abs/2504.12285 (BitNet b1.58 2B4T)
- https://android-developers.googleblog.com/2026/04/AI-Core-Developer-Preview.html
- File repo: /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md (sezioni 3.2, 5.2, 10.2)

---

## Slide 4 — Definizione
**Timing**: 6:00-8:00
**Tipo**: text

### Headline
Cos'e' un foundation model on-device

### Sottotitolo
E cosa **non** e'

### Body
**E'**: un LLM (1-4 B param.) eseguito interamente sul dispositivo — pesi, KV cache, inferenza tutto locale, nessun round-trip di rete.

**Non e'**:
- una chat che chiama un'API cloud (anche se il client e' mobile)
- un modello "edge" che gira su un server vicino (edge computing != on-device)
- un wrapper che usa Apple Private Cloud Compute o cloud privato

**Caso ibrido**: routing on-device → cloud per query complesse (Apple Intelligence pattern).

### Visual
- **Descrizione**: due colonne a confronto. A sinistra "On-device" con icona telefono e dentro un chip; a destra "NON e' on-device" con icona telefono e una freccia che esce verso una nuvola. Bordo verde per la prima, bordo rosso per la seconda.
- **Sorgente suggerita**: diagramma da generare basato su concepts_theory.md sezione 1.

### Speaker notes
Partiamo dalle definizioni perche' nel marketing degli ultimi dodici mesi "on-device" e' diventato un termine elastico. Per questo seminario useremo la definizione stretta: un foundation model on-device e' un large language model, tipicamente da uno a quattro miliardi di parametri, i cui pesi e la cui inferenza vivono interamente sul dispositivo dell'utente. Il dato non lascia mai il telefono. Cosa non rientra: una chat app che parla con OpenAI o Anthropic via API non e' on-device, anche se il client e' Swift o Kotlin. Un modello "edge" che gira su un server in rete locale non e' on-device, e' edge computing. E attenzione al pattern ibrido che Apple chiama Apple Intelligence: una parte gira sul telefono, ma le query complesse vengono ruotate verso Private Cloud Compute. E' un'architettura legittima, ma per oggi la consideriamo un caso a parte. Concentriamoci sulla cosa veramente nuova: il telefono che fa inferenza da solo.

### Riferimenti
- File repo: /Users/giadafranceschini/code/ai_foundation_model_mobile/concepts_theory.md (sezione 1)
- File repo: /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md (sezione 1)

---

## Slide 5 — Perche' ORA
**Timing**: 8:00-10:00
**Tipo**: diagram

### Headline
Perche' ORA — la convergenza dei tre fattori

### Sottotitolo
NPU + quantizzazione + SLM capable

### Body
- **NPU dedicate** (2023-2025): Apple Neural Engine (35-40 TOPS), Google Tensor TPU, Qualcomm Hexagon Gen 5 (~100 TOPS)
- **Quantizzazione aggressiva** (2024-2026): 4-bit standard, BitNet 1.58-bit, NanoQuant sub-1-bit
- **SLM "capable"** (2024-2026): Phi-3, Gemma 3n, Apple FM ~3B, Gemma 4 E2B/E4B — qualita' che 2 anni fa richiedeva 70 B parametri

### Tabella
| Anno | Sblocco |
|------|---------|
| 2023 | A17 Pro: primo Apple Intelligence-ready |
| 2024 | BitNet 1.58, Gemma 3n, Snapdragon 8 Elite |
| **apr 2026** | Gemma 4 GA, Gemini Nano 4 in AICore Preview |

### Visual
- **Descrizione**: diagramma di Venn a 3 cerchi sovrapposti — "Hardware NPU", "Quantizzazione <4-bit", "Modelli small+capable" — con al centro un'icona smartphone che si illumina. Sotto, timeline orizzontale 2023-2026 con i milestone.
- **Sorgente suggerita**: diagramma da generare a partire da SOTA_2026.md sezione 1.

### Speaker notes
La domanda giusta non e' "perche' on-device", e' "perche' on-device adesso e non due anni fa". La risposta e' una convergenza di tre curve indipendenti che si sono incontrate. Primo: l'hardware. Apple ha messo l'A17 Pro nell'iPhone 15 Pro a settembre 2023 con 35 TOPS di Neural Engine; Qualcomm ha portato l'Hexagon a circa cento TOPS con lo Snapdragon 8 Elite Gen 5 a settembre 2025. Avete ora chip mobili capaci di fare matmul a velocita' che fino al 2022 richiedevano un server. Secondo: la quantizzazione. Tra il 2024 e il 2026 sono arrivati BitNet a 1.58 bit nativi e NanoQuant sotto il bit per parametro: significa che modelli che avrebbero occupato decine di gigabyte ora ne occupano sotto i sei. Terzo: i modelli stessi. Phi-3, Gemma 3n, Apple Foundation Models — small language model che a tre miliardi di parametri reggono il confronto su molti task con i modelli da settanta miliardi del 2023. Quando tre curve si incontrano, e' a quel punto che nasce un mercato.

### Riferimenti
- File repo: /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md (sezioni 4, 5, 9)
- https://arxiv.org/abs/2504.12285 (BitNet)

---

## Slide 6 — I 4 vantaggi
**Timing**: 10:00-12:00
**Tipo**: tabella

### Headline
I 4 vantaggi dell'on-device

### Sottotitolo
Privacy, latenza, offline, costo zero

### Tabella
| Vantaggio | Cosa significa concretamente | Quando conta di piu' |
|-----------|------------------------------|----------------------|
| **Privacy** | I dati non lasciano mai il device — niente intercettazione, niente log lato server | Sanita', finanza, comunicazioni personali, contesti GDPR sensibili |
| **Latenza <100 ms** | Niente round-trip di rete: TTFT ~0.6 ms/token su Apple FM | Voice assistant, traduzione real-time, autocompletamento |
| **Offline** | Funziona in aereo, in metro, in zone senza copertura | App da campo, viaggi, emergenza, mercati emergenti |
| **Zero costo inferenza** | Costo computazionale sul device dell'utente, non sulla bolletta dello sviluppatore | App consumer scale, modelli di business freemium |

### Visual
- **Descrizione**: tabella verticale con 4 righe, ogni riga con una grande icona a sinistra (lucchetto, fulmine, aereo, banconota barrata) in #2ed6b1, colonne pulite, font Inter.
- **Sorgente suggerita**: tabella generata da concepts_theory.md sezione 1 + README.md.

### Speaker notes
Quattro vantaggi, ognuno e' una leva architetturale. Privacy: il dato non lascia il telefono. Per applicazioni sanitarie, finanziarie o di comunicazione personale questo e' il differenziatore principale — e in Europa con GDPR e' anche un acceleratore di compliance. Latenza: senza round-trip di rete il time-to-first-token sul modello Apple e' circa zero virgola sei millisecondi per token di prompt. Per voice assistant e traduzione simultanea questo e' il discrimine tra usabile e frustrante. Offline: la vostra app funziona in aereo, in metropolitana, in trekking. Sembra un dettaglio finche' non costruite un prodotto per turismo, agricoltura o emergenza. Quarto e forse piu' sottovalutato: zero costo di inferenza. Se avete un'app con cento mila utenti che fanno cinque query al giorno, in cloud parlate di cinque-dieci mila euro al mese minimo; on-device parlate di zero. Il costo e' sull'hardware dell'utente — che lo paga con un po' di batteria. Questo cambia il business model: il freemium AI diventa sostenibile.

### Riferimenti
- File repo: /Users/giadafranceschini/code/ai_foundation_model_mobile/concepts_theory.md (sezione 1, "Vantaggi dell'esecuzione locale")
- File repo: /Users/giadafranceschini/code/ai_foundation_model_mobile/README.md
- File repo: /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md (sezione 2.2 per TTFT Apple FM)

---

## Slide 7 — I 3 limiti
**Timing**: 12:00-14:00
**Tipo**: text

### Headline
I 3 limiti da accettare

### Sottotitolo
Onesta' tecnica: cosa l'on-device **non** sa fare

### Body
1. **Qualita' < frontier cloud**: un modello da 3 B param. non eguaglia GPT-4 / Claude Opus / Gemini Ultra su ragionamento complesso, knowledge ampio, code generation avanzato.
2. **Context window limitato**: Apple FM **4 096 token fissi**; Gemma 4 E2B/E4B 128 K teorici ma in pratica vincolati dalla RAM disponibile.
3. **Modello unico per app (Apple) o gestito dal sistema (Android)**: niente swap rapido di modello specializzato, niente fine-tuning runtime — solo LoRA adapter (Apple) o modelli open-source via LiteRT/MediaPipe (Android).

### Visual
- **Descrizione**: tre card verticali con badge numerato 1/2/3 in alto, titolo limite, descrizione breve. Bordo arancione/ambra per segnalare "trade-off". Icone: cervello con asterisco, finestra ridotta, lucchetto su slot.
- **Sorgente suggerita**: diagramma da generare da concepts_theory.md sezione 1 (sfide) e SOTA_2026.md sezione 2.2.

### Speaker notes
Onesta' intellettuale: l'on-device non e' magia, ha tre limiti precisi. Primo, la qualita'. Un modello da tre miliardi di parametri non eguaglia GPT-4, Claude Opus o Gemini Ultra su ragionamento multi-step complesso, knowledge enciclopedico ampio, o generazione di codice avanzato. Per task creativi, conversazionali, di sintesi, riscrittura — eccellente; per "scrivimi un paper di ricerca" — no. Secondo, il context window. Apple Foundation Models ha quattromilanovantasei token fissi, non modificabili. Gemma 4 sulla carta dichiara centoventotto K, ma in pratica sul telefono siete vincolati dalla RAM e finite quasi sempre sotto i sedicimila utili. Terzo limite, ed e' quello piu' fastidioso per chi viene dal cloud: avete un modello solo. Su Apple e' quello di Apple, non potete sostituirlo, potete solo aggiungere LoRA adapter da centosessanta megabyte; su Android avete piu' liberta' con LiteRT e MediaPipe ma vi gestite voi distribuzione e versioning. Bisogna progettare l'architettura accettando questi tre vincoli, non sperando che spariscano.

### Riferimenti
- File repo: /Users/giadafranceschini/code/ai_foundation_model_mobile/concepts_theory.md (sezione 1 "Sfide tecniche", sezione 2 "Context window fisso")
- File repo: /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md (sezione 2.2, sezione 3.1)

---

## Slide 8 — Decision tree
**Timing**: 14:00-16:00
**Tipo**: diagram

### Headline
On-device o cloud? Decision tree

### Sottotitolo
Quattro domande, una risposta

### Body
1. Il dato e' sensibile (sanita'/finanza/personale)? → **on-device**
2. Serve risposta sotto 100 ms o offline? → **on-device**
3. Volume di richieste alto + costo cloud insostenibile? → **on-device**
4. Serve ragionamento complesso, conoscenza enciclopedica, contesto >32 K token? → **cloud**

**Pattern ibrido raccomandato**: routing on-device per default, fallback cloud per query che superano una soglia di complessita'/contesto.

### Visual
- **Descrizione**: flowchart verticale con 4 nodi decisionali (rombi) collegati. Path on-device in verde #2ed6b1, path cloud in grigio. In basso un quinto nodo "ibrido" che fonde i due path con icona "router".
- **Sorgente suggerita**: diagramma da generare. Riferimento concettuale: SEMINAR.md slide 7 outline + comparisons.md sezione "Casi d'uso e raccomandazioni".

### Speaker notes
Quando un team mi chiede "on-device o cloud" gli rispondo sempre con quattro domande in ordine. Domanda uno: il dato e' sensibile? Sanita', finanza, comunicazione personale, dati biometrici? Se si', on-device chiude la conversazione di compliance. Domanda due: vi serve sotto i cento millisecondi di latenza, oppure deve funzionare offline? Voice, traduzione real-time, app da campo? Si', on-device. Domanda tre: il vostro volume di richieste rende il costo cloud insostenibile? Consumer app a milioni di utenti, modello freemium? Si', on-device. Domanda quattro, ed e' quella che ribalta: vi serve ragionamento complesso multi-step, conoscenza enciclopedica, contesto sopra trentadue K token? Allora cloud, oggi non c'e' alternativa. Il pattern raccomandato per la maggior parte dei prodotti reali e' ibrido: on-device per default, e una piccola euristica che fa routing al cloud quando serve. Apple Intelligence funziona esattamente cosi', con il loro Private Cloud Compute. E' la scelta che bilancia privacy, latenza, costo e qualita'.

### Riferimenti
- File repo: /Users/giadafranceschini/code/ai_foundation_model_mobile/SEMINAR.md (slide 7 outline)
- File repo: /Users/giadafranceschini/code/ai_foundation_model_mobile/comparisons.md (sezione "Casi d'uso e raccomandazioni")

---

## Slide 9 — Hardware NPU panoramica
**Timing**: 16:00-18:30
**Tipo**: tabella

### Headline
Hardware NPU 2025-2026

### Sottotitolo
Apple Neural Engine, Google Tensor TPU, Qualcomm Hexagon

### Tabella
| Chip | Dispositivo | NPU TOPS | Anno | Note |
|------|-------------|----------|------|------|
| A17 Pro | iPhone 15 Pro | 35 | set 2023 | Primo Apple Intelligence-ready |
| A18 / A18 Pro | iPhone 16 (Pro) | 35 | set 2024 | TSMC N3E, +17% bandwidth |
| **A19** | iPhone 17 / 17e | 38 | set 2025 | Neural Accelerators in GPU |
| **A19 Pro** | iPhone 17 Pro/Max, Air | 40+ | set 2025 | 3.1x GPU AI vs iPhone 16 Pro |
| **M5** | iPad Pro / Mac | n.d. | ott 2025 | Neural Accelerators in ogni GPU core |
| Tensor G4 | Pixel 9 | n.d. | ago 2024 | TPU Gen 3, Gemini Nano 2 |
| **Tensor G5** | Pixel 10 | +60% vs G4 | ago 2025 | 3nm TSMC, GPU PowerVR |
| Snapdragon 8 Elite | Flagship Android | ~45 | 2024 | Hexagon Gen 6 |
| **Snapdragon 8 Elite Gen 5** | Flagship Android 2025+ | **~100** | set 2025 | +37% Hexagon, >56 modelli in <5 ms |

### Visual
- **Descrizione**: tabella con tre raggruppamenti per vendor (Apple Silicon, Google Tensor, Qualcomm), header con logo del vendor. Colonna TOPS evidenziata con barre orizzontali proporzionali. Riga A19 Pro e Snapdragon 8 Elite Gen 5 evidenziate in #2ed6b1.
- **Sorgente suggerita**: tabella diretta da SOTA_2026.md sezioni 4.1, 4.3, 4.4.

### Speaker notes
Questa e' la mappa hardware che dovete tenere in mente quando scegliete il dispositivo target. Tre famiglie. Apple: l'A19 Pro nell'iPhone 17 Pro arriva a oltre quaranta TOPS sul Neural Engine, ma — attenzione — il salto vero rispetto all'A18 lo fanno i Neural Accelerators dentro la GPU, non l'NPU. Argmax misura tre virgola un volte la velocita' su inferenza Transformer GPU-bound rispetto all'iPhone 16 Pro, mentre il guadagno NE puro e' solo uno virgola zero-uno virgola quindici. Lezione: su Apple oggi il calcolo AI gira sempre piu' su GPU + ANE in cooperazione. Google: Tensor G5 sul Pixel 10 e' un salto di processo a tre nanometri TSMC, sessanta percento in piu' rispetto al G4. Qualcomm: lo Snapdragon 8 Elite Gen 5 di settembre 2025 raddoppia la generazione precedente arrivando intorno ai cento TOPS, e Google ha fatto un'integrazione specifica con LiteRT per sbloccare quelle performance su Hexagon per Gemma. Quando vedete numeri TOPS pero' ricordate: sono indicativi, le performance reali dipendono dal runtime, dal delegate, dalla quantizzazione del modello e dalla bandwidth memoria — questo lo vediamo nella prossima slide.

### Riferimenti
- File repo: /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md (sezioni 4.1, 4.2, 4.3, 4.4)
- https://en.wikipedia.org/wiki/Apple_A19
- https://blog.google/products-and-platforms/devices/pixel/tensor-g5-pixel-10/
- https://www.edge-ai-vision.com/2025/09/snapdragon-8-elite-gen-5-the-worlds-fastest-mobile-system-on-a-chip-establishes-new-consumer-benchmarks/
- https://www.argmaxinc.com/blog/iphone-17-on-device-inference-benchmarks

---

## Slide 10 — Energia NPU vs CPU
**Timing**: 18:30-20:30
**Tipo**: tabella

### Headline
Energia NPU vs CPU — il moltiplicatore nascosto

### Sottotitolo
Il vantaggio cresce con la lunghezza del contesto

### Tabella
| Lunghezza output | NPU vs CPU (energia) |
|------------------|----------------------|
| 64 token | **10-14x meno energia** |
| 1 024 token | **35-60x meno energia** |

### Body
- Su 64 token (risposta breve): NPU consuma 10-14 volte meno della CPU
- Su 1 024 token (risposta lunga): il vantaggio sale a 35-60 volte
- Implicazione: i modelli con context window estesi (128 K) sono drasticamente piu' efficienti su NPU
- Fonte: *Fast On-device LLM Inference with NPUs* — ASPLOS 2025

### Visual
- **Descrizione**: grafico a barre comparativo orizzontale. Asse Y: "64 tok" / "1024 tok". Due barre per ogni livello: CPU (grigia, lunga) vs NPU (verde #2ed6b1, corta). Annotazioni "10-14x" e "35-60x" sopra le barre. Etichetta in basso "Source: ASPLOS 2025".
- **Sorgente suggerita**: diagramma da generare. Dati da SOTA_2026.md sezione 10.3.

### Speaker notes
Se dovessi scegliere un singolo numero da farvi portare a casa da queste due ore, sarebbe questo. Il paper *Fast On-device LLM Inference with NPUs* presentato ad ASPLOS 2025 misura il consumo energetico per token su NPU rispetto alla CPU. Su una risposta breve di sessantaquattro token, la NPU consuma da dieci a quattordici volte meno energia della CPU per la stessa identica inferenza. Fin qui niente di sorprendente. Ma su una risposta lunga di milleventiquattro token, il vantaggio sale a trentacinque-sessanta volte. Trentacinque-sessanta volte. Questo significa due cose pratiche. Uno: girare un LLM sulla CPU del telefono — come fa di default llama.cpp se non configurate il backend giusto — e' un disastro per la batteria; va sempre delegato a NPU o GPU. Due: piu' lungo e' il contesto, piu' si amplifica il vantaggio del silicio dedicato. I modelli con context window estesi a centoventotto K che vedremo in Gemma 4 non sono solo piu' capaci, sono drammaticamente piu' efficienti — ma solo se l'inferenza gira sull'hardware giusto. Tenete in mente questo numero quando scegliete il runtime nelle prossime slide.

### Riferimenti
- https://xumengwei.github.io/files/ASPLOS25-NPU.pdf
- File repo: /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md (sezione 10.3)

---

## Slide 11 — Roadmap del seminario
**Timing**: 20:30-22:00
**Tipo**: diagram

### Headline
Cosa vediamo nelle prossime 8 sezioni

### Sottotitolo
Dalla teoria al codice che gira

### Body
1. **Apple FM Framework** — `LanguageModelSession`, guided generation, Tool protocol (15 min)
2. **Google Gemma 4 / Nano 4 / LiteRT-LM** — ML Kit GenAI, AICore (15 min)
3. **Hardware deep-dive** — Apple Silicon, Tensor, Snapdragon (10 min)
4. **Quantizzazione** — GGUF, AWQ, BitNet 1.58, NanoQuant (15 min)
5. **DEMO LIVE** — Swift + Kotlin sullo stesso problema (15 min)
6. **Pattern agentico** — Tool calling, FunctionGemma 270M (10 min)
7. **MCP su mobile** — stato e prospettive (5 min)
8. **Benchmark MLPerf v6.0** — numeri reali (5 min)

Poi: Q&A (10 min) + take-away (5 min).

### Visual
- **Descrizione**: mappa visiva 2x4 a griglia, ogni cella e' una sezione con icona, titolo, durata. Frecce orizzontali a indicare il flusso. Cella "DEMO LIVE" piu' grande e in #2ed6b1 con icona play. Sotto la griglia, marker "Sei qui" sulla cella Apple FM per anticipare la transizione.
- **Sorgente suggerita**: diagramma da generare basato su SEMINAR.md sezione 4 (slot 2-9).

### Speaker notes
Chiudiamo l'introduzione e apriamo il corpo del seminario. Vi anticipo la struttura di quello che segue cosi' avete sempre la mappa in mente. Andiamo subito su Apple — quindici minuti dedicati al Foundation Models Framework, vediamo `LanguageModelSession`, `@Generable` per la guided generation e il Tool protocol. Poi quindici minuti su Google: Gemma 4 con le quattro varianti, Gemini Nano 4 nel Developer Preview di AICore, e LiteRT-LM come runtime cross-platform. Dopo dieci minuti di hardware deep-dive — entriamo nel dettaglio di A19 Pro, Tensor G5, Snapdragon Elite Gen 5 — e quindici minuti sul tema che secondo me e' il vero abilitatore di tutto: la quantizzazione, da GGUF fino a BitNet 1.58 e NanoQuant. Al minuto settantacinque circa partiamo con la demo live: stesso problema risolto in Swift su iPhone e in Kotlin su Pixel. Poi pattern agentico, MCP, benchmark MLPerf v6.0, e finiamo con Q&A e take-away. La regola di prima vale ancora: interrompete in qualsiasi momento, soprattutto quando passiamo al codice. Cominciamo da Apple.

### Riferimenti
- File repo: /Users/giadafranceschini/code/ai_foundation_model_mobile/SEMINAR.md (sezione 4, slot 2-11)


---

# Blocco 2-3 — Apple e Google ecosystem (slide 12-29)

## Slide 12 — Apple Intelligence: la pila tecnologica
**Timing**: minuto 22
**Tipo**: diagram

### Headline
Apple Intelligence stack: tre layer, un solo silicio

### Sottotitolo
Foundation Models Framework, Core ML / Core AI, MLX

### Body (max 40 parole)
Tre layer software sopra Apple Silicon (Neural Engine + GPU Neural Accelerators). FM Framework per il modello sistema, Core ML per modelli custom convertiti, MLX per ricerca e LLM di terze parti con unified memory.

### Visual
- **Descrizione**: stack verticale a 4 livelli. Top: App Swift/SwiftUI. Layer 1: "Foundation Models Framework — `LanguageModelSession`, Tool, @Generable". Layer 2: "Core ML / Core AI (iOS 27, atteso)". Layer 3: "MLX / MLX Swift". Bottom: "Apple Silicon — Neural Engine + GPU Neural Accelerators (M5/A19 Pro)". Frecce verticali bidirezionali; colonna laterale "Private Cloud Compute" come fallback.
- **Sorgente suggerita**: diagramma vettoriale custom, palette Apple grays + accent blue.

### Speaker notes (150-200 parole)
Apple ha tre porte di ingresso all'AI on-device, e scegliere quella giusta dipende dal caso d'uso. Foundation Models Framework, introdotto a WWDC 2025, espone il modello sistema (~3B) tramite `LanguageModelSession`: zero download, zero costi, integrato in iOS 26+. Core ML resta lo strumento per portare modelli proprietari convertiti (ONNX/PyTorch via coremltools); a WWDC 2026 e' atteso il rebrand in "Core AI" come framework modernizzato per iOS 27 — fonte 9to5Mac, da trattare come rumor. MLX e' la libreria di ricerca Apple per array computing su Apple Silicon: sfrutta la unified memory ed e' la via raccomandata per LLM open source di terze parti (Qwen, Llama, Gemma) tramite MLX Swift. Da marzo 2026 anche Ollama integra MLX. Sotto, l'hardware: Neural Engine per i carichi NPU classici, e da M5/A19 Pro i Neural Accelerators dentro ogni core GPU per matmul. Private Cloud Compute e' la valvola di sfogo per richieste troppo grandi: stesso modello di privacy, infrastruttura Apple Silicon server.

### Riferimenti
- https://developer.apple.com/documentation/FoundationModels
- https://machinelearning.apple.com/research/exploring-llms-mlx-m5
- https://9to5mac.com/2026/03/01/apple-replacing-core-ml-with-modernized-core-ai-framework-for-ios-27-at-wwdc/
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md §2

---

## Slide 13 — Modello on-device Apple: dettagli architetturali
**Timing**: minuto 24
**Tipo**: tabella

### Headline
Il modello sistema iOS 26: ~3B parametri, 2-bit QAT, MoE sparse

### Sottotitolo
Trasformer denso + esperti, ottimizzato per A17 Pro e successivi

### Body (max 40 parole)
Architettura ibrida: backbone transformer + Mixture-of-Experts (64 expert ogni 2 layer). Pesi quantizzati 2-bit Quantization-Aware Training, embedding 4-bit, KV cache 8-bit. Context 4096 token. 16 lingue. ~30 tok/s su iPhone 15 Pro.

### Tabella
| Parametro | Valore |
|-----------|--------|
| Parametri | ~3 B |
| Architettura | Transformer + MoE sparse (64 expert ogni 2 layer) |
| Quantizzazione pesi | 2-bit QAT con scaling adattivo + EMA smoothing |
| Embedding | 4-bit |
| KV cache | 8-bit |
| Attenzione | Local sliding window alternata a global (global senza positional embeddings) |
| Context window | 4096 token (fisso) |
| Lingue | 16 (it, en, fr, de, es, pt-BR, zh-CN, ja, ko, ...) |
| Multimodal input | Immagini (vision-language adaptation module) |
| Tool calling | Si', costruito sopra guided generation |
| Throughput | ~30 tok/s su iPhone 15 Pro (A17 Pro), TTFT ~0.6 ms/prompt-token |

### Visual
- **Descrizione**: tabella due colonne, header bold, righe alternate. A destra mini-schema MoE: blocchi transformer con router ogni 2 layer che seleziona 2-4 expert su 64.
- **Sorgente suggerita**: tabella nativa nel deck + mini-diagramma MoE custom.

### Speaker notes (150-200 parole)
Il modello on-device Apple condensa tre anni di ricerca su efficienza. Tre numeri da ricordare: 3 miliardi di parametri totali, 2 bit per peso (Quantization-Aware Training, non post-training: la quantizzazione e' parte del training), 4096 token di context fisso. La scelta MoE e' chirurgica: invece di 3B densi, si attivano per ogni token solo gli esperti rilevanti — meno energia, meno banda di memoria. Il KV cache a 8-bit e' cruciale: nei modelli a context lungo il KV diventa il vero collo di bottiglia di memoria, non i pesi. Throughput tipico ~30 token/secondo su A17 Pro: sufficiente per UI streaming fluido. La copertura linguistica ufficiale e' 16 lingue ma le performance variano: italiano, inglese, francese, tedesco, spagnolo sono first-class; cinese semplificato, giapponese, coreano sono coperti ma con qualita' inferiore al cloud. Importante per l'audience: questi numeri sono fissi — non potete scegliere un modello piu' grande o piu' context. E' il prezzo dell'integrazione gratuita.

### Riferimenti
- https://machinelearning.apple.com/research/apple-foundation-models-tech-report-2025
- https://arxiv.org/abs/2507.13575
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md §2.2

---

## Slide 14 — `LanguageModelSession`: chat e streaming
**Timing**: minuto 26
**Tipo**: code

### Headline
Tre righe per una chat, una per lo streaming

### Sottotitolo
L'API base di Foundation Models Framework

### Body (max 40 parole)
`LanguageModelSession` mantiene il transcript della conversazione automaticamente. `respond(to:)` per risposta completa, `streamResponse(to:)` per token-by-token. Verificare sempre `isAvailable` prima dell'uso.

### Codice
```swift
import FoundationModels

// 1. Disponibilita' + sessione con instructions
guard LanguageModelSession.isAvailable else { return }

let config = LanguageModelSession.Configuration(
    instructions: "Sei un assistente. Rispondi in italiano."
)
let session = LanguageModelSession(configuration: config)

// 2. Risposta singola
let response = try await session.respond(to: "Spiega il Neural Engine in 2 frasi.")
print(response.content)

// 3. Streaming token-by-token
let stream = session.streamResponse(to: "Riassumi MLX in 5 punti.")
for try await partial in stream {
    updateUI(partial.content)   // partial cumulativo, non delta
}
```

### Visual
- **Descrizione**: blocco codice full-width, syntax highlighting Swift. Tre commenti numerati `// 1.`, `// 2.`, `// 3.` con badge laterale colorato.
- **Sorgente suggerita**: snippet nel deck + screenshot Xcode opzionale di backup.

### Speaker notes (150-200 parole)
Questo e' il "Hello World" del Foundation Models Framework. Tre cose da notare. Primo, `isAvailable` e' una guardia non opzionale: il modello c'e' solo su dispositivi Apple Intelligence-ready (iPhone 15 Pro+, M-series Mac/iPad). Su un iPhone 14 questa property e' false e dovete avere un fallback — UI degradata o cloud. Secondo, `Configuration.instructions` e' il system prompt: persiste per tutta la vita della session. Terzo, la differenza fra `respond` e `streamResponse`: `respond` blocca finche' non arriva la risposta intera (~1-3 secondi tipici); `streamResponse` ritorna un AsyncSequence dove ogni `partial.content` e' la stringa cumulativa finora generata, non un delta — questo semplifica il binding all'UI ma attenzione a non concatenare manualmente. Il file completo e' in `examples/ios/BasicChat.swift` e `examples/ios/StreamingChat.swift`: includono ViewModel `@Observable`, gestione errori, e un'interfaccia SwiftUI pronta. Cancellation: cancellando il Task SwiftUI la sessione si ferma automaticamente.

### Riferimenti
- /Users/giadafranceschini/code/ai_foundation_model_mobile/examples/ios/BasicChat.swift
- /Users/giadafranceschini/code/ai_foundation_model_mobile/examples/ios/StreamingChat.swift
- https://developer.apple.com/videos/play/wwdc2025/259/

---

## Slide 15 — `@Generable` e guided generation
**Timing**: minuto 28
**Tipo**: code

### Headline
Output strutturato garantito a livello di tipo Swift

### Sottotitolo
`@Generable` + `respond(generating:)` = niente JSON parsing fragile

### Body (max 40 parole)
Annotando una struct con `@Generable` e i campi con `@Guide`, il modello produce direttamente un'istanza Swift type-safe. La validita' (enum, vincoli di lunghezza) e' garantita dal grammar-constrained decoding interno.

### Codice
```swift
@Generable
struct ConceptCard {
    @Guide(description: "Titolo del concetto, max 60 caratteri")
    var title: String

    @Guide(.anyOf(["base", "intermedio", "avanzato"]))
    var level: String

    @Guide(description: "Spiegazione in massimo 3 frasi")
    var explanation: String
}

let session = LanguageModelSession()

let card = try await session.respond(
    to: "Crea una scheda concetto per: quantizzazione 4-bit",
    generating: ConceptCard.self
)

print(card.title)        // String tipato
print(card.level)        // garantito in {base, intermedio, avanzato}
print(card.explanation)
```

### Visual
- **Descrizione**: codice a sinistra (60% larghezza); a destra una "card" UI mockup con i tre campi popolati: titolo "Quantizzazione 4-bit", level chip "intermedio", explanation. Freccia dall'output codice alla card.
- **Sorgente suggerita**: snippet + mockup statico.

### Speaker notes (150-200 parole)
Il guided generation e' l'arma segreta di FM Framework. Sotto il cofano e' grammar-constrained decoding: a ogni token il sampler considera solo i token che mantengono valida la grammatica indotta dal tipo Swift. Risultato: niente piu' parsing JSON con `try?`, niente piu' "il modello a volte dimentica una virgola". L'attributo `@Guide` ha due forme: descrittiva (`description:`, suggerisce semantica al modello) e vincolante (`.anyOf`, `.range`, `.pattern` — vincoli rigidi). Funziona ricorsivamente: potete annidare struct `@Generable` o usare array, optional, enum. Use case tipici: estrarre entita' da testo (persona, data, importo), generare configurazioni UI, classificare in tassonomie chiuse. Limite pratico: schema troppo complessi (>15-20 campi nested) degradano qualita' — meglio decomporre in piu' chiamate. Lo snippet completo nel SEMINAR.md sezione 6.2 mostra anche l'integrazione con SwiftUI: il tipo generato e' direttamente bindabile a una View senza layer di mapping.

### Riferimenti
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SEMINAR.md §6.2
- https://developer.apple.com/documentation/FoundationModels
- /Users/giadafranceschini/code/ai_foundation_model_mobile/concepts_theory.md

---

## Slide 16 — Tool protocol: function calling nativo
**Timing**: minuto 30
**Tipo**: code

### Headline
Estendere il modello con strumenti Swift: protocollo `Tool`

### Sottotitolo
Il framework gestisce il loop tool-call -> execute -> response

### Body (max 40 parole)
Conformare un tipo a `Tool`: nome, descrizione, struct `Parameters` `@Generable`, `call(with:)`. Passarlo alla session via `tools:`. Il modello decide quando chiamarlo e il framework esegue automaticamente.

### Codice
```swift
struct WeatherTool: Tool {
    let name = "getWeather"
    let description = "Ottiene il meteo attuale per una citta'"

    @Generable
    struct Parameters: Codable {
        let city: String
        let units: TemperatureUnits

        @Generable
        enum TemperatureUnits: String, Codable {
            case celsius, fahrenheit
        }
    }

    func call(with parameters: Parameters) async throws -> String {
        // In produzione: WeatherKit, REST API, ...
        return "A \(parameters.city) ci sono 22 gradi e sole."
    }
}

let session = LanguageModelSession(
    configuration: .init(instructions: "Usa i tool quando opportuno."),
    tools: [WeatherTool(), CalculatorTool(), ReminderTool()]
)

let r = try await session.respond(to: "Che tempo fa a Bologna?")
// Il framework chiama WeatherTool.call dietro le quinte
print(r.content)
```

### Visual
- **Descrizione**: codice 70% larghezza. A destra sequence diagram: User -> Session -> "model decides" -> Tool.call -> Tool result -> Session -> User. Cinque step numerati.
- **Sorgente suggerita**: snippet + sequence diagram.

### Speaker notes (150-200 parole)
Il `Tool` protocol e' il punto di ingresso per gli agenti on-device su Apple. Architetturalmente: il modello vede la lista dei tool come parte del prompt sistema (nome + description + schema dei Parameters derivato dal `@Generable`), decide a runtime se chiamarne uno, emette tokens speciali di tool-call, il framework parser-decoda, esegue la funzione `call(with:)` Swift, inietta il risultato nel transcript, il modello continua. Tre regole di igiene. Uno: la `description` e' il vostro prompt — piu' e' chiara, piu' il modello indovina quando usare il tool. Due: i Parameters devono essere `@Generable` perche' il framework usa lo stesso meccanismo del guided generation per garantire che il modello produca argomenti validi. Tre: `call` puo' essere asincrona, lanciare errori, fare I/O — ma timeout e cancellation sono responsabilita' vostra. L'esempio completo in `examples/ios/ToolCallingExample.swift` registra tre tool (Weather, Calculator, Reminder) e mostra come visualizzare le tool call invocate nell'UI per debug.

### Riferimenti
- /Users/giadafranceschini/code/ai_foundation_model_mobile/examples/ios/ToolCallingExample.swift
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SEMINAR.md §6.2
- /Users/giadafranceschini/code/ai_foundation_model_mobile/deep_dives/function_calling.md

---

## Slide 17 — iOS 26.4: `contextSize` e `tokenCount(for:)`
**Timing**: minuto 32
**Tipo**: code

### Headline
Marzo 2026: gestione difensiva del context window 4096

### Sottotitolo
Due API additive, `@backDeployed` su tutti gli iOS 26.0+

### Body (max 40 parole)
iOS 26.4 espone `SystemLanguageModel.default.contextSize` (4096 token oggi) e `session.tokenCount(for:)` per misurare un prompt prima di inviarlo. Pattern: troncare o resettare prima di sforare il context.

### Codice
```swift
// iOS 26.4+ — additive, retrocompatibile via @backDeployed
let model = SystemLanguageModel.default
let ctxLimit = model.contextSize         // 4096 (fisso al 2026-04)

// Prima di inviare un nuovo turno
let estimate = try await session.tokenCount(for: nextMessage)
let used = session.transcript.estimatedTokenCount

if used + estimate > ctxLimit {
    // Strategie possibili:
    // a) reset session preservando le instructions
    session = LanguageModelSession(configuration: cfg, tools: tools)
    // b) compattare: chiedere al modello un riassunto e ripartire
    // c) sliding window manuale del transcript
}

let r = try await session.respond(to: nextMessage)
```

### Visual
- **Descrizione**: codice full-width. In alto a destra badge "iOS 26.4 - marzo 2026" + icona `@backDeployed`. Sotto il codice, mini-progress bar "used / 4096 token" con tre stati colorati (verde <70%, giallo 70-90%, rosso >90%).
- **Sorgente suggerita**: snippet + barra visuale custom.

### Speaker notes (150-200 parole)
Il context window di 4096 token e' il vincolo piu' stringente del modello sistema Apple. Fino a iOS 26.3 era una black box: superato il limite, errore opaco a runtime. iOS 26.4 introduce due API additive per gestirlo difensivamente. `contextSize` espone il limite (oggi 4096, ma WWDC 2026 dovrebbe alzarlo — rumor). `tokenCount(for:)` misura quanti token consumera' un prompt PRIMA di inviarlo: cruciale per UI multi-turno dove si accumula contesto. Entrambe sono `@backDeployed(before: iOS 26.4)`: il symbol e' incluso nel binary della vostra app, quindi funziona anche su iOS 26.0-26.3 — nessuna availability check necessaria, nessuna breaking change. Tre strategie tipiche al superamento: reset (perde il contesto, ok per task indipendenti), compaction (chiedete al modello un riassunto della conversazione e ripartite con quello come instruction), sliding window (mantenete solo gli ultimi N turni). Compaction e' la piu' sofisticata e quella che gli assistenti di produzione usano in cloud — funziona anche on-device ma costa una chiamata extra al modello.

### Riferimenti
- https://developer.apple.com/documentation/technotes/tn3193-managing-the-on-device-foundation-model-s-context-window
- https://www.infoq.com/news/2026/03/apple-foundation-models-context/
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md §2.1

---

## Slide 18 — MLX e Neural Accelerators M5
**Timing**: minuto 34
**Tipo**: text

### Headline
M5 + MLX = TTFT 4.06x piu' veloce del M4

### Sottotitolo
Neural Accelerators dentro ogni core GPU per matmul dedicato

### Body (max 40 parole)
M5 (ottobre 2025) integra circuiti matmul nei core GPU. Misurazioni Apple ML Research su Qwen3-14B-4bit: TTFT 4.06x vs M4, generation 1.19x. MacBook Pro M5 Pro/Max disponibili da marzo 2026. Ollama integra MLX dal Q1 2026.

### Tabella
| Metrica | M4 | M5 | Speedup |
|---------|----|----|---------|
| TTFT (Qwen3-14B-4bit) | baseline | — | **4.06x** |
| Generation tok/s | baseline | — | **1.19x** |
| GPU AI peak | baseline | — | ~4x |
| Neural Accelerators GPU | No | Si' (1 per core) | — |

### Visual
- **Descrizione**: barre comparate orizzontali (M4 vs M5) per i quattro indicatori. Sotto, illustrazione di un chip con grid di GPU core, ciascuno con mini-blocco "NA" (Neural Accelerator) sovrimpresso.
- **Sorgente suggerita**: chart + mockup chip custom; foto MacBook Pro M5 da apple.com newsroom.

### Speaker notes (150-200 parole)
Punto chiave: l'NPU non e' piu' il solo posto dove si fa AI su Apple Silicon. M5 ha aggiunto circuiti matmul dedicati dentro ogni core GPU — Apple li chiama "Neural Accelerators GPU". Questo e' significativo perche' il Neural Engine ha banda di memoria limitata; la GPU ne ha molta di piu', e ora puo' sfruttarla per matmul senza pagare la traduzione kernel grafici -> kernel ML. Risultato misurato da Apple ML Research su Qwen3-14B quantizzato a 4 bit: il time-to-first-token e' 4.06 volte piu' veloce su M5 rispetto a M4, mentre la generation e' "solo" 1.19x — coerente con il fatto che il prefill e' compute-bound, la decode e' memory-bandwidth-bound. MLX e' la libreria che sfrutta direttamente questi acceleratori: e' array computing in stile NumPy ma con unified memory (no copy CPU-GPU) ed e' la via raccomandata per LLM open source. Da marzo 2026 anche Ollama lo integra: significa che `ollama run llama3` su M5 usa MLX sotto. Per iOS, MLX Swift e' la versione mobile della stessa storia.

### Riferimenti
- https://machinelearning.apple.com/research/exploring-llms-mlx-m5
- https://www.apple.com/newsroom/2026/03/apple-introduces-macbook-pro-with-all-new-m5-pro-and-m5-max/
- https://appleinsider.com/articles/26/03/31/ollama-is-supercharged-by-mlxs-unified-memory-use-on-apple-silicon
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md §2.3

---

## Slide 19 — LoRA Adapters: customizzare il modello sistema
**Timing**: minuto 36
**Tipo**: diagram

### Headline
Adapter LoRA per specializzare il modello senza riaddestrarlo

### Sottotitolo
Workflow training + entitlement App Store dedicato

### Body (max 40 parole)
LoRA aggiunge piccole matrici a basso rango ai layer del modello base. Apple fornisce il **Foundation Models adapter training toolkit** (Python + Jupyter); per la distribuzione App Store serve l'entitlement `com.apple.developer.foundation-model-adapter`. Adapter ~MB, non GB.

### Visual
- **Descrizione**: tre fasi orizzontali con frecce. (1) "Dati custom" -> (2) "Train LoRA adapter" (Foundation Models adapter training toolkit, Python + Jupyter) -> (3) "Distribuisci con app" (icona App Store + bundle `.fmadapter` ~10-50 MB) -> "Runtime: SystemLanguageModel + adapter caricato". Sotto la fase 3 banner: "Entitlement `com.apple.developer.foundation-model-adapter` richiesto per distribuzione App Store".
- **Sorgente suggerita**: diagramma flow custom.

### Speaker notes (150-200 parole)
LoRA — Low-Rank Adaptation — e' la tecnica di fine-tuning piu' diffusa nel 2024-2026: invece di aggiornare tutti i pesi del modello base, si aggiungono matrici A·B di rango basso (es. r=8) ai layer di attenzione, e si addestrano solo quelle. Risultato: adapter da pochi MB invece di un modello completo da GB. Apple supporta il pattern via Foundation Models Framework: il tooling ufficiale e' il **Foundation Models adapter training toolkit**, distribuito da Apple Developer come pacchetto Python con Jupyter notebook e utility per esportare bundle `.fmadapter`. Bundle l'adapter con la vostra app e a runtime il sistema lo applica al modello base. Tre vincoli importanti. Uno: per distribuire adapter su App Store serve l'entitlement `com.apple.developer.foundation-model-adapter`, richiesto dall'Account Holder del Developer Program — training/test locale non lo richiedono. Due: l'adapter si applica solo al modello sistema corrente; se Apple aggiorna il modello (succede tra iOS minor), gli adapter vanno ricompilati. Tre: il use case sweet spot e' terminologia di dominio (medicale, legale, gaming) o stile (brand voice). Per logica complessa o knowledge nuova, RAG resta piu' affidabile.

### Riferimenti
- https://developer.apple.com/apple-intelligence/foundation-models-adapter/
- https://developer.apple.com/documentation/FoundationModels
- https://machinelearning.apple.com/research/apple-foundation-models-2025-updates
- /Users/giadafranceschini/code/ai_foundation_model_mobile/concepts_theory.md

---

## Slide 20 — Private Cloud Compute: privacy by design
**Timing**: minuto 38
**Tipo**: diagram

### Headline
Quando il modello on-device non basta: PCC, non un cloud qualunque

### Sottotitolo
Stessi standard di privacy del dispositivo, hardware Apple Silicon server

### Body (max 40 parole)
Per richieste oltre le capacita' del modello on-device, FM Framework puo' fare fallback a Private Cloud Compute: server Apple Silicon dedicati, codice firmato e auditabile pubblicamente, nessun log persistente, attestation crittografica end-to-end.

### Visual
- **Descrizione**: due colonne. Sinistra "On-device" (icona iPhone, lock chiuso, "tutto rimane locale"). Destra "Private Cloud Compute" (server con scudo Apple, bullet: "Apple Silicon server", "Sealed software image", "Pubblico audit", "No data persistence", "Attestation per-request"). Linea tratteggiata fra le due con etichetta "Solo se on-device insufficiente, con consenso utente".
- **Sorgente suggerita**: diagramma custom.

### Speaker notes (150-200 parole)
Private Cloud Compute e' la risposta di Apple alla domanda "cosa succede quando il modello on-device non basta?". Annunciato a WWDC 2024 e in produzione dal 2025, e' la stessa architettura di privacy del dispositivo, estesa a server Apple Silicon dedicati. Tre garanzie tecniche distintive. Uno: la software image che gira su PCC e' firmata e pubblicata; ricercatori esterni possono auditarla — nessuna "trust me bro" privacy policy. Due: nessun dato persistente — la richiesta viene processata in memoria e scartata, niente log, niente training dati. Tre: attestation crittografica per-richiesta — il dispositivo verifica che il server sia esattamente l'image audited, altrimenti rifiuta di inviare i dati. Per il developer FM Framework astrae il fallback: la stessa API `respond` puo', dietro le quinte, andare a PCC per richieste complesse. Comparazione concettuale con Google: Private Compute Core su Pixel e' simile per filosofia ma vive on-device, non server. Approfondimento in `concepts_theory.md`. Per il vostro design: PCC e' una valvola di sicurezza, non il pattern di default — l'on-device resta la prima scelta.

### Riferimenti
- https://security.apple.com/blog/private-cloud-compute/
- /Users/giadafranceschini/code/ai_foundation_model_mobile/concepts_theory.md
- /Users/giadafranceschini/code/ai_foundation_model_mobile/deep_dives/personal_intelligence.md

---

## Slide 21 — WWDC 2026: cosa aspettarsi (rumor / non confermato)
**Timing**: minuto 40
**Tipo**: text

### Headline
WWDC 2026 (8-12 giugno): Core AI, Siri Gemini, Siri Extensions

### Sottotitolo
Anticipazioni da fonti multiple — tutto da considerare "non confermato"

### Body (max 40 parole)
Calendario confermato, keynote no. Quattro temi attesi: rebrand Core ML -> Core AI per iOS 27, backend Siri basato su Google Gemini, Siri Extensions per backend alternativi (Claude, Gemini, Grok, Copilot), context window espanso oltre 4096 token.

### Tabella
| Tema | Stato | Fonte |
|------|-------|-------|
| Core AI framework (iOS 27) | Rumor alta confidenza | 9to5Mac |
| Siri Gemini-powered | Rumor alta confidenza | TechCrunch, MacRumors |
| Siri Extensions (backend selezionabile) | Rumor | AppleInsider |
| Context window > 4096 | Atteso, non confermato | Inferenza da iOS 26.4 |
| API multimodale immagini pubblica | Atteso | Inferenza |
| Migliore supporto fine-tuning | Atteso | Inferenza |

### Visual
- **Descrizione**: tabella con colonna stato colorata (giallo "rumor", arancione "atteso"). In alto badge molto evidente "RUMOR - NON CONFERMATO" rosso. Calendario WWDC 8-12 giugno 2026 in basso.
- **Sorgente suggerita**: tabella nativa + badge.

### Speaker notes (150-200 parole)
Disclaimer in apertura: tutto in questa slide e' rumor o inferenza, non conferme Apple. Il calendario WWDC 2026 e' ufficiale (8-12 giugno), il keynote no. Cosa aspettarsi con alta confidenza. Primo: Core ML diventa Core AI — non solo rebrand, framework modernizzato per iOS 27 con tooling unificato per modelli classici e foundation models. Due fonti indipendenti (9to5Mac, MacRumors). Secondo, sorprendente: il backend del nuovo Siri sarebbe basato su Gemini di Google. Apple Intelligence per il modello sistema on-device, Siri per dialogo conversazionale tramite cloud Gemini. Strategicamente sensato — Apple riconosce di essere indietro su LLM frontier. Terzo: Siri Extensions, l'utente sceglie Claude/Gemini/Grok/Copilot come backend alternativo. Equivalente Siri della scelta browser EU. Quarto, inferenza tecnica: iOS 26.4 ha esposto `contextSize` come property dinamica — e' chiaramente predisposto a cambiare. Aspettatevi context window 8K-16K. Per gli studenti: questo slide non sara' accurato fra un mese — ed e' il punto, mostrare che il dominio si muove veloce e bisogna seguire le fonti primarie.

### Riferimenti
- https://techcrunch.com/2026/03/23/apple-wwdc-june-8-12-ai-advancements-siri-developers-conference/
- https://9to5mac.com/2026/03/01/apple-replacing-core-ml-with-modernized-core-ai-framework-for-ios-27-at-wwdc/
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md §2.4

---

## Slide 22 — Android AI stack: dall'app al silicio
**Timing**: minuto 42
**Tipo**: diagram

### Headline
Android: stack a 4 livelli, due API surfaces

### Sottotitolo
ML Kit GenAI (high-level) o AICore (low-level), entrambi su LiteRT-LM

### Body (max 40 parole)
App Android -> ML Kit GenAI APIs (Summarization, Rewriting, Image Description) **oppure** AICore (Gemini Nano diretto, Prompt API) -> LiteRT-LM runtime cross-platform -> Hardware (Tensor TPU, Snapdragon Hexagon, MediaTek APU).

### Visual
- **Descrizione**: stack verticale 4 layer (specchio della slide 12 per parallelismo). Top: "App Android (Kotlin/Compose)". Layer 1 in due colonne: "ML Kit GenAI APIs (task-oriented)" | "AICore SDK (Prompt API, Gemini Nano)". Layer 2: "LiteRT-LM (runtime cross-platform)". Bottom: "Hardware: Tensor G5 TPU - Snapdragon 8 Elite Gen 5 Hexagon - MediaTek APU". Annotazione laterale: "Pixel 9+, Galaxy S24/S25 = supporto GA".
- **Sorgente suggerita**: diagramma vettoriale custom, palette Google sobri.

### Speaker notes (150-200 parole)
La struttura Android e' simmetrica a quella Apple ma con un bivio in piu' al layer API. Al top, l'app Kotlin/Compose. Al layer API ci sono due porte di ingresso: ML Kit GenAI APIs offrono task-oriented endpoints — Summarization, Rewriting, Proofreading, Image Description, Prompt — pronti all'uso, zero configurazione, ottimi per integrazioni rapide. AICore SDK e' il livello sotto: accesso diretto a Gemini Nano via Prompt API (free-form), maggiore controllo, ideale per agenti e use case custom. Entrambi delegano a LiteRT-LM, il runtime cross-platform di Google AI Edge che da Google I/O 2025 e' il successore di MediaPipe LLM Inference. Sotto, l'hardware e' frammentato: Tensor G5 di Pixel 10 ha la TPU di terza generazione; Snapdragon 8 Elite Gen 5 ha Hexagon NPU a ~100 TOPS; MediaTek e Samsung Exynos hanno proprie APU. La frammentazione e' il problema strutturale di Android — Google la mitiga con LiteRT che astrae i delegate hardware-specific. Disponibilita' GA: Pixel 9+, Samsung Galaxy S24/S25 series; altri OEM in rollout.

### Riferimenti
- https://developer.android.com/ai/gemini-nano/ml-kit-genai
- https://ai.google.dev/edge/litert-lm/overview
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md §3

---

## Slide 23 — Gemini Nano: storia in quattro versioni
**Timing**: minuto 44
**Tipo**: text

### Headline
Da Nano-1 (1.8B testo) a Nano-4 (Gemma 4 multimodale)

### Sottotitolo
Quattro generazioni in due anni, ogni step un cambio di base model

### Body (max 40 parole)
Nano-1 (Pixel 8 Pro, dic. 2023): 1.8 B, solo testo. Nano-2: variante 3.25 B parametri. Nano-3: versione attuale su Pixel 9/10 (parametri non comunicati ufficialmente da Google). Nano-4 (aprile 2026): backbone Gemma 4 E2B/E4B, audio/video nativi, tool calling.

### Tabella
| Versione | Anno | Parametri | Base | Capabilities |
|----------|------|-----------|------|--------------|
| Nano-1 | dic 2023 | 1.8 B | proprietario (Gemini) | Testo |
| Nano-2 | 2024 | 3.25 B | proprietario (Gemini) | Testo, context esteso |
| Nano-3 | 2025 | n.d. (non comunicato) | non comunicato ufficialmente | + Immagini |
| **Nano-4** | apr 2026 | E2B (~2B) / E4B (~4B) | **Gemma 4** | + Audio/Video, **tool calling**, 128K ctx |

### Visual
- **Descrizione**: timeline orizzontale 2023->2026 con 4 nodi (uno per versione), icona per capability accumulata (testo / context / immagine / audio-video-tool). Sotto ogni nodo dispositivo di riferimento (Pixel 8 Pro -> 9 -> 10).
- **Sorgente suggerita**: timeline custom.

### Speaker notes (150-200 parole)
Gemini Nano e' il modello sistema Android, equivalente concettuale del modello on-device Apple. La storia e' un crescendo di capabilities. Nano-1 a dicembre 2023 era proprietario (1.8 B parametri), solo testo, rilasciato con Pixel 8 Pro come prova di concetto. Nano-2 ha portato 3.25 B parametri e context esteso. Nano-3 nel 2025 ha aggiunto multimodalita' immagini ed e' la versione corrente su Pixel 9/10 — Google non ha pubblicato parametri ne' base model ufficiali, quindi mi astengo dal citare numeri non verificati. Il salto piu' recente e' Nano-4: AICore Developer Preview da aprile 2026, basato esplicitamente su Gemma 4 E2B (Fast, ~4.2 GB on-disk) ed E4B (Full, ~5.9 GB). Qui arrivano audio + video nativi, tool calling come feature first-class, context 128K. Il pattern strategico e' chiaro: con Nano-4 Google unifica la famiglia — la stessa codebase Gemma copre cloud, edge e mobile. Apple invece tiene il modello sistema separato e proprietario. Trade-off: Apple ha controllo totale e privacy by default; Google ha cadenza di release piu' rapida e capabilities superiori, ma con minore trasparenza sui parametri intermedi.

### Riferimenti
- https://9to5google.com/2026/04/02/gemini-nano-4-android/
- https://android-developers.googleblog.com/2026/04/AI-Core-Developer-Preview.html
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md §3.2

---

## Slide 24 — Gemma 4: quattro varianti, una codebase
**Timing**: minuto 46
**Tipo**: tabella

### Headline
Gemma 4 (rilasciato 2 aprile 2026): mobile, edge, server

### Sottotitolo
E2B / E4B / 26B-A4B MoE / 31B Dense — tool calling nativo in tutte

### Body (max 40 parole)
Quattro modelli scalano dallo smartphone (E2B, 8 GB RAM) al server (31B Dense). E2B/E4B co-design con Qualcomm/MediaTek per mobile. Tutte: multimodalita' testo/immagini/video/audio nativa, tool calling, thinking modes, 140+ lingue.

### Tabella
| Variante | Tipo | Parametri attivi | Context | RAM device | Use case |
|----------|------|-----------------|---------|------------|----------|
| **E2B** | Dense mobile (sparse activation) | ~2 B | 128 K | 8 GB | Mobile latency-first |
| **E4B** | Dense mobile | ~4 B | 128 K | 12 GB | Mobile qualita' |
| 26B-A4B | MoE | 26 B (4 B attivi) | 256 K | 24 GB | Edge server / laptop |
| 31B Dense | Dense | 31 B | 256 K | Server | Server / workstation |

### Visual
- **Descrizione**: tabella full-width. A destra, quattro icone dispositivi (smartphone / smartphone-pro / laptop / server) sotto le varianti corrispondenti, in scala. Footer con sei badge feature: "Tool calling nativo" - "Thinking modes" - "Multimodale T/I/V/A" - "140+ lingue" - "LiteRT-LM / MLX / llama.cpp / Ollama" - "Gemma Terms of Use".
- **Sorgente suggerita**: tabella + icone custom.

### Speaker notes (150-200 parole)
Gemma 4 e' il rilascio open weights piu' importante del 2026 per il mobile. Quattro varianti in una sola codebase. Le due "E" — E2B ed E4B — sono progettate co-design con Qualcomm e MediaTek: i layer e le quantizzazioni sono ottimizzati per girare su Hexagon e APU specifici. E2B e' la variante latency-first, ~2B parametri attivi (con sparse activation per ridurre il compute), gira in 8 GB RAM. E4B e' la sweet spot qualita': ~4B, ancora 128K context, vuole 12 GB. La 26B-A4B e' MoE con 26B totali ma solo 4B attivi per token: target laptop / edge server. La 31B Dense e' server-only. Quattro caratteristiche trasversali importanti. Tool calling nativo in tutte: niente piu' dipendenza da fine-tuning custom per agenti. Thinking modes commutabili: chain-of-thought attivabile a runtime — piu' qualita', piu' latenza. Multimodalita' testo/immagini/video/audio nativa anche su mobile (E2B/E4B). 140+ lingue con qualita' migliorata su lingue low-resource. Pipeline ufficiali coprono LiteRT-LM, MLX, llama.cpp, Ollama, vLLM, Vertex AI — multi-runtime per design.

### Riferimenti
- https://blog.google/innovation-and-ai/technology/developers-tools/gemma-4/
- https://ai.google.dev/gemma/docs/core
- https://huggingface.co/blog/gemma4
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md §3.1

---

## Slide 25 — MatFormer (Gemma 3n) + Per-Layer Embeddings (Gemma 4)
**Timing**: minuto 48
**Tipo**: diagram

### Headline
Due tecniche mobile-first che attraversano due release Gemma

### Sottotitolo
MatFormer introdotto con Gemma 3n (2025), PLE ereditato in Gemma 4 E2B/E4B

### Body (max 40 parole)
**MatFormer** (Matryoshka Transformer) — feature **Gemma 3n**: un singolo training produce sub-modelli annidati selezionabili a runtime. **Per-Layer Embeddings (PLE)** — usato in **Gemma 4 E2B/E4B**: ogni layer ha embedding dedicato; riduce footprint memoria a parita' di qualita'.

### Visual
- **Descrizione**: due pannelli affiancati con label di versione. SINISTRA "Gemma 3n — MatFormer": matrioska di tre rettangoli annidati — il modello piccolo e' un sotto-set di pesi del grande. DESTRA "Gemma 4 E2B/E4B — PLE": stack di transformer layer, ciascuno con il proprio piccolo blocco "embedding" attaccato (vs schema classico con un grande embedding condiviso al fondo). Frecce annotate.
- **Sorgente suggerita**: diagramma concettuale custom.

### Speaker notes (150-200 parole)
Due innovazioni architetturali rendono mobile-first la famiglia Gemma. MatFormer — Matryoshka Transformer — e' stato introdotto con **Gemma 3n** nel 2025 (non con Gemma 4): e' una tecnica di training che produce in una singola run un modello "elastico", addestrate il modello grande con loss pesate su sub-network di dimensioni crescenti e ottenete gratis sub-modelli piu' piccoli che sono letteralmente un subset coerente dei pesi del grande. La documentazione Gemma 4 attuale non cita MatFormer come feature delle varianti E2B/E4B. Per-Layer Embeddings (PLE) e' invece il meccanismo che `ai.google.dev/gemma/docs/core` attribuisce esplicitamente a Gemma 4 E2B/E4B. PLE attacca un problema specifico mobile: l'embedding table e' uno dei piu' grandi consumatori di memoria nei piccoli LLM. Invece di un grande embedding globale, PLE da' a ogni layer un piccolo embedding specializzato — totale parametri simile, ma migliore information flow e quantizzazione piu' efficace. A parita' di qualita', footprint memoria ridotto. La distinzione MatFormer (Gemma 3n) vs PLE (Gemma 4) e' importante perche' la confusione e' diffusa anche in articoli di settore.

### Riferimenti
- https://ai.google.dev/gemma/docs/core (Gemma 4, PLE)
- https://ai.google.dev/gemma/docs/gemma-3n (Gemma 3n, MatFormer)
- https://huggingface.co/blog/rishiraj/matformer-in-gemma-3n
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md §3.1

---

## Slide 26 — ML Kit GenAI APIs: Summarization in Kotlin
**Timing**: minuto 50
**Tipo**: code

### Headline
Task-oriented API: cinque righe per riassumere un articolo

### Sottotitolo
Summarization, Rewriting, Proofreading, Image Description, Prompt — tutti GA

### Body (max 40 parole)
ML Kit GenAI offre endpoint pronti per i task piu' comuni. Builder pattern, output type configurabile (one bullet, three bullets, one paragraph), runInference asincrona. GA su Pixel 9+ e Samsung Galaxy S24/S25.

### Codice
```kotlin
// build.gradle: implementation "com.google.mlkit:genai-summarization:..."

import com.google.mlkit.genai.summarization.Summarization
import com.google.mlkit.genai.summarization.SummarizerOptions

// 1. Summarization (ML Kit GenAI)
val summarizer = Summarization.getClient(
    SummarizerOptions.builder(context)
        .setOutputType(SummarizerOptions.OutputType.ONE_BULLET)
        .build()
)
val summary: String = summarizer.runInference(longArticle).get()

// 2. Prompt API (free-form, AICore)
import com.google.ai.edge.aicore.GenerativeModel
import com.google.ai.edge.aicore.generationConfig

val model = GenerativeModel(
    generationConfig = generationConfig {
        temperature = 0.7f; topK = 40; maxOutputTokens = 1024
    },
    systemInstruction = "Sei un assistente. Rispondi in italiano."
)
val chat = model.startChat()
val response = chat.sendMessage("Spiega LiteRT-LM in 3 punti.")
print(response.text)
```

### Visual
- **Descrizione**: codice full-width. Due blocchi numerati: blocco 1 (ML Kit GenAI Summarization, ~8 righe), blocco 2 (AICore Prompt API, ~12 righe). Sopra ogni blocco header con badge: "task-oriented" / "free-form".
- **Sorgente suggerita**: snippet nel deck.

### Speaker notes (150-200 parole)
Confronto pratico fra le due porte di ingresso Android. ML Kit GenAI e' la via piu' pigra e in molti casi la migliore: registrate il client con `SummarizerOptions`, scegliete il formato output (un bullet, tre bullets, un paragrafo), chiamate `runInference()`. Zero gestione del prompt, zero tuning di parametri — ottima per integrare summarization in app news, e-commerce, produttivita'. Stato GA su Pixel 9+ e Galaxy S24/S25 series. AICore Prompt API e' un livello sotto: `GenerativeModel` con `generationConfig` (temperature, topK, topP, maxOutputTokens), `systemInstruction` come system prompt, `startChat()` per mantenere il contesto multi-turn. E' l'equivalente Android di `LanguageModelSession` di Apple — stessa filosofia, API leggermente piu' verbose. Il file `examples/android/BasicChatActivity.kt` mostra la versione completa con ViewModel, StateFlow, Compose UI. `examples/android/MediaPipeLLMExample.kt` mostra anche l'alternativa MediaPipe LLM Inference per modelli custom (GGUF/LiteRT scaricati a runtime) — utile se volete usare modelli che non sono Gemini Nano.

### Riferimenti
- /Users/giadafranceschini/code/ai_foundation_model_mobile/examples/android/BasicChatActivity.kt
- /Users/giadafranceschini/code/ai_foundation_model_mobile/examples/android/MediaPipeLLMExample.kt
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SEMINAR.md §6.3
- https://developer.android.com/ai/gemini-nano/ml-kit-genai

---

## Slide 27 — LiteRT-LM: il runtime cross-platform
**Timing**: minuto 52
**Tipo**: diagram

### Headline
LiteRT-LM rimpiazza progressivamente MediaPipe LLM Inference

### Sottotitolo
Un solo runtime: Android, iOS, Chrome, Pixel Watch, IoT

### Body (max 40 parole)
Da Google I/O 2025, LiteRT-LM e' il runtime raccomandato. Open source, cross-platform (Android, iOS, Chrome/Chromebook Plus, Pixel Watch, desktop, IoT). Delegate chipset-aware mitigano la varianza NNAPI fra vendor (Snapdragon ±12%, Exynos ±52%).

### Visual
- **Descrizione**: hub centrale "LiteRT-LM Runtime" con sei raggi verso piattaforme: Android, iOS, Chrome, Pixel Watch, Desktop, IoT. Sotto, badge "Open source — github.com/google-ai-edge/LiteRT-LM". A destra mini-tabella varianza NNAPI: "Snapdragon 8 Gen 2: ±12% - Exynos 2400: ±52%".
- **Sorgente suggerita**: diagramma hub-and-spoke custom.

### Speaker notes (150-200 parole)
LiteRT-LM e' la storia di consolidamento del runtime di Google AI Edge. Fino al 2024 c'erano TensorFlow Lite (general purpose), MediaPipe LLM Inference (per LLM), e una serie di binding ad-hoc. Da Google I/O 2025, LiteRT e' il successore unificato di TFLite, e LiteRT-LM e' il layer specifico LLM su LiteRT. MediaPipe LLM Inference resta disponibile per backward compatibility ma non riceve nuove feature — chi parte oggi parte da LiteRT-LM. Il valore differenziante e' la copertura cross-platform: lo stesso runtime gira su Android, iOS, Chrome, Chromebook Plus, Pixel Watch, desktop, IoT — significa che potete deployare lo stesso modello quantizzato (es. Gemma 4 E2B in formato `.litert`) su tutti questi target con la stessa pipeline. Punto critico per Android: la varianza NNAPI fra vendor e' documentata e drammatica — Snapdragon 8 Gen 2 ±12%, Exynos 2400 ±52%. LiteRT con delegate chipset-aware (Hexagon, GPU, NNAPI fallback) e' la via pratica per performance prevedibili senza scrivere codice vendor-specific. Repository pubblico: github.com/google-ai-edge/LiteRT-LM.

### Riferimenti
- https://ai.google.dev/edge/litert-lm/overview
- https://github.com/google-ai-edge/LiteRT-LM
- https://developers.googleblog.com/litert-the-universal-framework-for-on-device-ai/
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md §3.3

---

## Slide 28 — FunctionGemma 270M: tool calling specializzato
**Timing**: minuto 54
**Tipo**: text

### Headline
FunctionGemma 270M: 85% accuracy Mobile Actions in 270 milioni di parametri

### Sottotitolo
Modello derivato da Gemma 3 270M, specializzato per function calling edge

### Body (max 40 parole)
Pubblicato dicembre 2025. 256K vocab, 32K context, training su 6T token. Accuracy "Mobile Actions" 85% vs 58% del base. Gira su NVIDIA Jetson Nano e smartphone moderni. Resta utile per dispositivi ultra-resource-constrained, anche con Gemma 4 nativo.

### Tabella
| Caratteristica | Valore |
|----------------|--------|
| Parametri | 270 M |
| Vocab | 256 K |
| Context | 32 K |
| Training tokens | 6 T |
| Accuracy Mobile Actions eval | **85%** (vs 58% baseline Gemma 3 270M) |
| Hardware target | NVIDIA Jetson Nano, smartphone moderni |
| Modello pubblico | google/functiongemma-270m-it (HuggingFace) |
| Use case sweet spot | Edge dispositivi a bassa RAM, pipeline specializzate |

### Visual
- **Descrizione**: tabella nativa. A destra, mini bar chart accuracy: Gemma 3 270M baseline 58% (barra grigia) vs FunctionGemma 270M 85% (barra evidenziata). Sotto, tre badge dispositivi target: "Jetson Nano - Wear OS - IoT smart speaker".
- **Sorgente suggerita**: tabella + bar chart custom.

### Speaker notes (150-200 parole)
FunctionGemma e' un esercizio di specializzazione estrema. Partendo da Gemma 3 270M — un modello tiny da 270 milioni di parametri — Google lo ha addestrato esclusivamente su dati di function calling: 6 trilioni di token di esempi di tool invocation, JSON schema, parsing di intent. Risultato sorprendente: sull'eval interno "Mobile Actions" raggiunge 85% di accuracy, dove il base Gemma 3 270M faceva 58%. La ragione: function calling e' un task fortemente strutturato, una grammatica chiusa — non serve un modello general purpose grande. Use case sweet spot oggi: dispositivi ultra-resource-constrained (Wear OS, smart speaker IoT, hardware embedded come Jetson Nano), o pipeline dove un modello generale chiama un dispatcher specializzato — pattern "small model decide, big model execute". Da considerare: con Gemma 4 che integra tool calling nativo direttamente in E2B/E4B, FunctionGemma diventa una nicchia. Resta attraente quando avete vincoli di memoria sotto 1GB o quando volete un modello dedicato per l'orchestrazione che non condivida risorse con il modello "intelligente". Modello pubblico su HuggingFace, license Gemma Terms of Use.

### Riferimenti
- https://huggingface.co/google/functiongemma-270m-it
- https://blog.google/technology/developers/functiongemma/
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md §3.5
- /Users/giadafranceschini/code/ai_foundation_model_mobile/deep_dives/function_calling.md

---

## Slide 29 — AICore Developer Preview: come accedere oggi a Gemini Nano 4
**Timing**: minuto 56
**Tipo**: tabella

### Headline
AICore Developer Preview (aprile 2026): Gemini Nano 4 Fast vs Full

### Sottotitolo
4x piu' veloce, -60% batteria, multimodale nativo, 128K context

### Body (max 40 parole)
Due varianti basate su Gemma 4. Fast (E2B, 8 GB RAM, 2 GB storage) per latenza; Full (E4B, 12 GB RAM, 4 GB storage) per qualita'. Disponibilita' consumer GA attesa H2 2026.

### Tabella
| Variante | Base | RAM | Storage | Velocita' relativa |
|----------|------|-----|---------|--------------------|
| **Nano 4 Fast** | Gemma 4 E2B | 8 GB | 2 GB | 3x piu' veloce di Full |
| **Nano 4 Full** | Gemma 4 E4B | 12 GB | 4 GB | baseline (qualita' superiore) |

**Caratteristiche comuni**:
- Fino a 4x piu' veloce delle versioni Nano precedenti
- -60% consumo batteria
- Multimodale nativo: testo / immagini / audio
- 128K context window
- 140+ lingue
- Tool calling nativo
- Disponibilita': AICore Developer Preview (aprile 2026), GA consumer attesa H2 2026

### Visual
- **Descrizione**: tabella due righe ben contrastata (Fast vs Full). Sotto, sei badge per le caratteristiche comuni in griglia 3x2. A destra, dispositivo target Pixel 10 con label "AICore Developer Preview".
- **Sorgente suggerita**: tabella + grid di feature badge.

### Speaker notes (150-200 parole)
Chiusura del blocco Google con il prodotto consumer concreto: AICore Developer Preview, disponibile da aprile 2026. Due varianti che mappano direttamente sui due "E" di Gemma 4. Nano 4 Fast usa E2B come backbone, vuole 8 GB RAM e occupa 2 GB di storage — e' la latency-first, target Pixel 9/10 standard. Nano 4 Full usa E4B, vuole 12 GB RAM e 4 GB storage — e' la qualita'-first, target Pixel Pro e Galaxy S25 Ultra. La differenza di velocita' e' 3x: Fast e' tre volte piu' veloce di Full, a costo di qualita' inferiore. Quattro numeri trasversali da ricordare: 4x piu' veloce delle versioni Nano precedenti, -60% di consumo batteria, 128K context (32x rispetto al modello on-device Apple), 140+ lingue. Tool calling nativo significa che non serve FunctionGemma per agenti — Gemini Nano 4 lo fa direttamente. Stato: Developer Preview ora, GA consumer attesa H2 2026 (probabilmente Google I/O maggio o successivo). Per accedere, registrazione al programma developer Google + dispositivo Pixel 9+ aggiornato. Cross-reference: i benchmark MLPerf v6.0 (slide successiva nel blocco hardware) misureranno proprio questi modelli.

### Riferimenti
- https://android-developers.googleblog.com/2026/04/AI-Core-Developer-Preview.html
- https://9to5google.com/2026/04/02/gemini-nano-4-android/
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md §3.2


---

# Blocco 4-5 — Agenti, MCP, Quantizzazione, Benchmark (slide 30-42)

## Slide 30 — Architetture agentiche on-device: panorama
**Timing**: 60' cumulativi (00:60-00:62)
**Tipo**: text + diagram

### Headline
Tre famiglie di agenti che girano oggi sul telefono

### Sottotitolo
ReAct, Plan-and-Execute, Mobile-Agent-v2 a confronto

### Body (max 40 parole)
Un LLM diventa agente quando entra in un loop percezione-ragionamento-azione con tool esterni. Su mobile dominano tre pattern: ReAct (reasoning + acting interleaved), Plan-and-Execute (piano upfront + esecutore), Mobile-Agent-v2 (multi-agente specializzato per phone automation).

### Tabella
| Pattern | Idea chiave | Forza | Costo su mobile |
|---------|-------------|-------|-----------------|
| ReAct | Thought-Action-Observation in loop | Riduce hallucination via feedback reale | 3-5 iterazioni max consigliate |
| Plan-and-Execute | Piano completo, poi executor | Meno chiamate LLM totali | Replanning costoso se il piano salta |
| Mobile-Agent-v2 | 3 agenti (Planning/Decision/Reflection) | +30% task completion vs single-agent | Richiede 3 inference per step |

### Visual
- **Descrizione**: tre box affiancati, uno per pattern, con loop frecce diverse (ReAct = ciclo stretto; Plan-and-Execute = freccia lineare con ramo replan; Mobile-Agent-v2 = tre agenti collegati).
- **Sorgente suggerita**: diagramma originale, ispirato a `deep_dives/agentic_architectures.md` (loop agentico) e `SOTA_2026.md` §6.1.

### Speaker notes (180 parole)
Fino a un anno fa l'agente on-device era un'idea da paper. Oggi sui telefoni con 8-12 GB di RAM e un modello da 2-4 miliardi di parametri si possono eseguire loop agentici realistici, purche brevi. ReAct, introdotto da Yao et al. nel 2023, e il pattern piu semplice: l'LLM produce un Thought, sceglie un'Action, riceve un'Observation e ripete. Funziona bene per tool calling singolo, ma soffre se servono molti step. Plan-and-Execute scinde il problema: un planner produce in anticipo la sequenza di sotto-task, un executor la esegue. Costa meno chiamate LLM ma e fragile quando il piano va replannato. Mobile-Agent-v2, presentato a NeurIPS 2024, sceglie la strada multi-agente: un planning agent comprime la storia, un decision agent decide il prossimo tap, un reflection agent corregge gli errori. Risultato: +30% di task completion su benchmark di phone automation. La regola pratica per il telefono: massimo 3-5 iterazioni, timeout 10-15 secondi, tool set ridotto a 3-5 funzioni ben definite.

### Riferimenti
- https://arxiv.org/abs/2210.03629 (ReAct)
- https://neurips.cc/virtual/2024/poster/95398 (Mobile-Agent-v2)
- deep_dives/agentic_architectures.md
- SOTA_2026.md §6.1

---

## Slide 31 — Mobile-Agent-v2 deep dive
**Timing**: 62' cumulativi (00:62-00:64)
**Tipo**: diagram

### Headline
Tre agenti, +30% task completion

### Sottotitolo
Planning, Decision, Reflection: la divisione del lavoro che funziona

### Body (max 40 parole)
NeurIPS 2024. Il Planning agent comprime la storia delle operazioni in testo puro per ridurre il contesto. Il Decision agent sceglie l'azione successiva sullo screenshot corrente. Il Reflection agent rileva esiti inattesi e propone correzioni. Risultato: +30% task completion vs baseline single-agent.

### Visual
- **Descrizione**: diagramma a tre colonne. Sopra: utente + task. Tre box agenti (Planning, Decision, Reflection) connessi al device GUI. Frecce mostrano: history compressa entra in Planning -> contesto entra in Decision -> azione sul telefono -> screenshot -> Reflection -> retry o ack.
- **Sorgente suggerita**: diagramma originale basato su NeurIPS 2024 paper poster.

### Speaker notes (180 parole)
La cosa interessante di Mobile-Agent-v2 e che il problema risolto e prima di tutto di context budget. Quando un agente naviga un'app per dieci passi, il transcript cresce in fretta: screenshot codificati come testo, ogni tap, ogni risultato. Su un modello con 4096 token di contesto, dopo cinque step sei gia saturo. La soluzione del paper: il Planning agent non vede mai gli screenshot grezzi, vede solo un testo compresso prodotto dopo ogni step. Il Decision agent, invece, vede screenshot e contesto compresso e produce l'azione concreta. Il Reflection agent e il quality check: confronta lo screenshot atteso con quello osservato e, se diverge, rilancia. La metrica +30% di task completion e su benchmark di phone automation rispetto al baseline single-agent dello stesso modello. Lezione architettonica per noi: su mobile, scomporre i ruoli e quasi sempre meglio che ingrandire il modello. Tre chiamate a un 3B-parameter sono migliori di una chiamata a un 9B-parameter quando ognuna ha un ruolo definito e un input pulito.

### Riferimenti
- https://neurips.cc/virtual/2024/poster/95398
- SOTA_2026.md §6.1

---

## Slide 32 — Memoria episodica: quattro tipologie
**Timing**: 64' cumulativi (00:64-00:66)
**Tipo**: tabella + text

### Headline
Senza memoria non c'e agente

### Sottotitolo
Episodic, Semantic, Procedural, Working: cosa sono e perche contano

### Body (max 40 parole)
mem0.ai 2026: il gap "ha memoria / non ha memoria" e spesso piu grande del gap tra backbone LLM diversi. Quattro tipologie usate in produzione, con ruoli distinti. Su mobile, la context window 2-4K rende la gestione esplicita non opzionale.

### Tabella
| Tipo | Cosa contiene | Esempio mobile | Storage tipico |
|------|---------------|----------------|----------------|
| Working | Stato del task corrente | Carrello in corso, intent attivo | Context window LLM |
| Episodic | Log delle interazioni recenti | Ultime 50 chat, ultimi tap | SQLite locale |
| Semantic | Fatti e KB sull'utente | Preferenze, contatti, calendario | Vector DB on-device |
| Procedural | Pattern e procedure apprese | Workflow ripetuti, scorciatoie | LoRA adapter / rule store |

### Visual
- **Descrizione**: piramide a 4 livelli (dal basso: Procedural, Semantic, Episodic, Working) con etichetta latency / persistence sul lato.
- **Sorgente suggerita**: diagramma originale, ispirato a `deep_dives/agentic_architectures.md` §Gestione della memoria.

### Speaker notes (180 parole)
La citazione di mem0.ai del 2026 vale la pena di rileggerla: il gap tra "agente con memoria" e "agente senza memoria" e spesso piu grande del gap tra backbone LLM diversi. Tradotto: vale piu la pena investire in un sistema di memoria decente con un modello da 3B che usare un modello da 9B senza memoria. Le quattro tipologie hanno ruoli distinti. Working memory e la context window: e quello che il modello vede ora. Episodic memory e il log: cosa hai fatto ieri, due ore fa, l'ultima sessione. Semantic memory e la KB stabile: chi sei, cosa ti piace, i tuoi contatti. Procedural memory e l'esperienza: come hai risolto problemi simili, quali tool hanno funzionato. Su mobile la sfida e dove tenerle. Working sta nei 4096 token Apple. Episodic e Semantic vivono in SQLite + un vector DB locale (es. ObjectBox, sqlite-vss). Procedural e l'area piu sperimentale: alcuni progetti la codificano in LoRA adapter distillati. Graph memory, sperimentale nel 2024, e passata in produzione a inizio 2026 secondo mem0.

### Riferimenti
- https://mem0.ai/blog/state-of-ai-agent-memory-2026
- deep_dives/agentic_architectures.md (sezione Gestione della memoria)
- SOTA_2026.md §6.2

---

## Slide 33 — Pattern: agente personale offline end-to-end
**Timing**: 66' cumulativi (00:66-00:68)
**Tipo**: diagram

### Headline
Sensori, memoria, tool, output: tutto sul telefono

### Sottotitolo
Architettura di riferimento per un personal agent on-device

### Body (max 40 parole)
Un agente personale offline non e un LLM con prompt. E una pipeline: input multimodali dai sensori, recupero da memoria locale, ragionamento on-device, invocazione di tool nativi (Calendar, Contacts, HealthKit), output. Il cloud e opt-in, non default.

### Visual
- **Descrizione**: diagramma orizzontale a 5 stadi.
  1. INPUT: microfono / camera / screen / location / notifiche
  2. MEMORY: vector DB + SQLite (Episodic + Semantic)
  3. REASONING: foundation model 3B on-device (Apple FM o Gemma 4 E2B)
  4. TOOLS: Calendar, Contacts, HealthKit, Reminders, MCP server locali
  5. OUTPUT: notifica / vocale / azione UI / scrittura su app
  Sotto, una banda "Privacy boundary": tutto on-device. Una freccia tratteggiata opzionale verso "Cloud fallback (Private Cloud Compute / Private Compute Core)".
- **Sorgente suggerita**: diagramma originale, ispirato a `deep_dives/agentic_architectures.md` §Implementazione su mobile + SOTA_2026.md §3.6 (Personal Intelligence Pixel 10).

### Speaker notes (180 parole)
Questo e il diagramma che vorrei steste imprimete in mente. Un agente personale offline non e un wrapper attorno a un modello: e una pipeline a cinque stadi dove il modello e solo lo stadio centrale. A sinistra, gli input: il telefono e ricco di sensori, e la maggior parte del valore sta nell'integrarli. Subito dopo la memoria, perche senza memoria l'agente e amnesico ad ogni interazione. Al centro il modello on-device: oggi parliamo di Apple Foundation Model 3B o Gemma 4 E2B. A destra i tool nativi: Calendar, Contacts, HealthKit su iOS; ContentResolver, Intent equivalenti su Android. Lo strato di output e il piu sottovalutato: un agente che parla bene ma non agisce e un chatbot, non un agente. La banda "Privacy boundary" e fondamentale per il pitch del pattern: tutto resta sul dispositivo, il cloud e una scelta esplicita dell'utente per task complessi (Private Cloud Compute Apple, Private Compute Core Google). E questa proprieta architettonica, non la qualita del modello, che giustifica gli investimenti on-device.

### Riferimenti
- deep_dives/agentic_architectures.md (Implementazione su mobile)
- SOTA_2026.md §3.6 (Magic Cue, Voice Translate, Nano Banana on-device)
- SOTA_2026.md §6.2 (Memory systems)

---

## Slide 34 — GUI agents per phone automation
**Timing**: 68' cumulativi (00:68-00:70)
**Tipo**: text + diagram

### Headline
L'agente che usa l'app al posto tuo

### Sottotitolo
Screenshot-driven + DOM hybrid: stato e sfide aperte

### Body (max 40 parole)
Survey aprile 2026 (arXiv 2504.19838): due famiglie. Screenshot-driven con touch su coordinate (modello vede pixel). Hybrid DOM + vision (testo accessibilita + screenshot). Limiti documentati su screentext vs screenshot. Sfide aperte: dataset diversity, deployment efficiency, security.

### Visual
- **Descrizione**: due colonne affiancate.
  - Colonna A "Screenshot-driven": telefono -> screenshot -> VLM -> coordinate (x, y) -> tap.
  - Colonna B "Hybrid DOM + vision": telefono -> AccessibilityTree + screenshot -> LLM con grounding -> action ID -> intent.
  Sotto, riga di rischi: prompt injection da contenuti di pagina, falsi click, perdita di stato.
- **Sorgente suggerita**: diagramma originale basato su arXiv 2504.19838.

### Speaker notes (180 parole)
I GUI agents sono l'area piu calda del 2026 dopo MCP. La survey di aprile classifica due famiglie. La prima: screenshot-driven. Il modello multimodale guarda i pixel dello schermo, decide dove toccare in coordinate assolute. E quello che fa Mobile-Agent-v2. Funziona ovunque, ma e fragile alle variazioni di UI. La seconda: hybrid DOM + vision. Sfrutta l'accessibility tree del sistema (UIAccessibility su iOS, AccessibilityNodeInfo su Android) per avere un grounding testuale stabile, e usa lo screenshot solo come riferimento visivo. E piu robusto, ma dipende dalla qualita dei label di accessibilita dell'app. Un paper recente, arXiv 2604.17817, documenta che screentext puro batte spesso lo screenshot puro per task ben strutturati. Le sfide aperte sono quattro, dichiarate dalla survey: poca diversita nei dataset di training, deployment efficiency on-device (non basta che funzioni in cloud), user-centric adaptation (l'agente deve imparare le abitudini di un utente specifico), security. Quest'ultimo e il piu sottovalutato: un agente che agisce sull'app e una nuova superficie di prompt injection.

### Riferimenti
- https://arxiv.org/abs/2504.19838 (GUI Agents Survey)
- https://arxiv.org/html/2604.17817v1 (screentext vs screenshot)
- SOTA_2026.md §6.3

---

## Slide 35 — Model Context Protocol: cos'e e dov'e
**Timing**: 70' cumulativi (00:70-00:72)
**Tipo**: text + numeri

### Headline
MCP: lo standard de facto per tool calling cross-vendor

### Sottotitolo
97M download/mese, Linux Foundation, 10K+ server pubblici

### Body (max 40 parole)
Anthropic propone MCP nel 2024. Ad aprile 2026: 97M download mensili degli SDK Python+TS, 10.000+ server pubblici, donato alla Linux Foundation con OpenAI, Google, Microsoft come co-sponsor. Tutti i provider lo hanno adottato. Standard aperto, due transport: stdio e Streamable HTTP.

### Tabella
| Aspetto | Stato aprile 2026 |
|---------|-------------------|
| Download SDK (Python + TS) | 97M / mese |
| Server pubblici | 10.000+ |
| Governance | Linux Foundation |
| Co-sponsor | Anthropic, OpenAI, Google, Microsoft, Salesforce |
| Transport principali | stdio (locale), Streamable HTTP (remoto) |
| Prossima spec | giugno 2026 |

### Visual
- **Descrizione**: schema architetturale. Host (es. Claude Desktop) -> MCP client -> due frecce: una verso server locale stdio (filesystem, calendar), una verso server remoto HTTP (Salesforce, GitHub).
- **Sorgente suggerita**: diagramma originale ispirato a https://modelcontextprotocol.io/specification/2025-11-25.

### Speaker notes (180 parole)
MCP e nato in Anthropic a fine 2024 come tentativo di standardizzare il modo in cui un LLM scopre e invoca tool esterni. In meno di due anni e diventato lo standard de facto del settore. I numeri di marzo 2026: 97 milioni di download mensili tra SDK Python e TypeScript, oltre diecimila server MCP pubblici censiti, donazione alla Linux Foundation con OpenAI, Google, Microsoft e Salesforce come co-sponsor. La cosa interessante e che ha vinto perche e un protocollo, non un framework: definisce lo schema dei messaggi (JSON-RPC 2.0), la modalita di discovery dei tool, il formato di prompt e risposte. Due transport: stdio per server locali (e quello che useremo su mobile come sidecar di processo), Streamable HTTP per server remoti, evoluzione del precedente SSE che permette scaling orizzontale. La prossima release della specifica e prevista per giugno 2026, in concomitanza con WWDC e Google I/O. Il messaggio per chi sta progettando ora: se costruite tool calling proprietario, state costruendo legacy. Adottate MCP.

### Riferimenti
- https://modelcontextprotocol.io/specification/2025-11-25
- https://blog.modelcontextprotocol.io/posts/2026-mcp-roadmap/
- SOTA_2026.md §7.1, §7.2
- deep_dives/function_calling.md

---

## Slide 36 — MCP su mobile: oggi e domani
**Timing**: 72' cumulativi (00:72-00:74)
**Tipo**: text

### Headline
Sul telefono MCP esiste, ma e ancora developer-only

### Sottotitolo
Android Studio Gemini Agent Mode oggi, consumer atteso H2 2026

### Body (max 40 parole)
Aprile 2026: Android Studio + Gemini Agent Mode integrano MCP per il developer. Su Android consumer (Gemini Nano / AICore in app) MCP non e ancora pubblicamente documentato. Apple non ha annunciato supporto MCP nativo. Aspettativa annunci: Google I/O 2026 e WWDC 2026.

### Tabella
| Ambiente | Stato MCP aprile 2026 |
|----------|----------------------|
| Android Studio + Gemini Agent Mode | Supportato (developer tooling) |
| Android consumer (AICore / Gemini Nano in app) | Non documentato pubblicamente |
| iOS (Apple Foundation Models) | Nessun annuncio nativo; integrazioni via framework terzi |
| Cross-platform mobile | SDK TypeScript usabile in React Native via wrapper |
| Aspettativa consumer | Annunci probabili a Google I/O 2026 / WWDC 2026 |

### Visual
- **Descrizione**: timeline orizzontale. Tre tappe: (1) "oggi - Android Studio Agent Mode", (2) "giu 2026 - WWDC + Google I/O atteso annuncio consumer", (3) "H2 2026 - rollout consumer atteso". Nessun marker per iOS oggi.
- **Sorgente suggerita**: timeline originale basata su SOTA_2026.md §7.3.

### Speaker notes (180 parole)
Quando si parla di MCP su mobile, bisogna distinguere due livelli. Il primo: developer tooling. Qui Android e gia avanti: Google ha integrato MCP in Android Studio con Gemini Agent Mode, lo strumento che permette a Gemini di leggere il codice, modificarlo, lanciare comandi via server MCP locali. La documentazione e su developer.android.com/studio/gemini/add-mcp-server. Il secondo livello: consumer in-app. Qui siamo ancora a zero pubblicato. Su Android, l'integrazione di MCP con Gemini Nano via AICore non e documentata pubblicamente al 29 aprile 2026. Su iOS, Apple non ha annunciato alcun supporto nativo a MCP nei Foundation Models, e gli unici percorsi sono via framework di terze parti che impacchettano lo stack. La cross-platform via React Native e tecnicamente possibile usando l'SDK TypeScript, ma e un wrapper, non un'integrazione nativa. L'aspettativa fondata: il prossimo big bang di MCP consumer mobile arriva a Google I/O 2026 (maggio) e WWDC 2026 (8-12 giugno). Se progettate un'app agentica oggi, costruite l'astrazione tool oggi e siate pronti a switchare a MCP quando arriva.

### Riferimenti
- https://developer.android.com/studio/gemini/add-mcp-server
- https://blog.modelcontextprotocol.io/posts/2026-mcp-roadmap/
- SOTA_2026.md §7.3
- deep_dives/function_calling.md

---

## Slide 37 — Quantizzazione: il panorama 2026
**Timing**: 74' cumulativi (00:74-00:76)
**Tipo**: tabella

### Headline
Otto formati / metodi che dovete conoscere

### Sottotitolo
GGUF, AWQ, GPTQ, AQLM, HQQ, SpinQuant, NVFP4, MXFP4

### Body (max 40 parole)
Non esiste "la" quantizzazione: ogni metodo ha trade-off su bit, calibration data, hardware target. Tabella sintetica: nome, bit tipici, metodo, pro, contro. Da usare come decision aid per scegliere il formato giusto rispetto al device target.

### Tabella
| Nome | Bit tipici | Metodo | Pro | Contro |
|------|------------|--------|-----|--------|
| GGUF (Q4_K_M) | 4 | PTQ block-wise | CPU + Apple Silicon nativo, ecosistema llama.cpp | Quality 92%, no GPU NVIDIA ottimizzata |
| AWQ | 4 | PTQ activation-aware | Quality 95%, ottimo per instruction-tuned | Throughput inferiore (67 tok/s vLLM) |
| GPTQ | 4 | PTQ layer-wise | Veloce su GPU NVIDIA (712 tok/s con Marlin) | Quality 90%, richiede calibration set |
| AQLM | <2 | Additive quantization | Pareto-ottimale sotto 2 bit per modelli 70B+ | Compression time elevato |
| HQQ | 4-8 | PTQ half-quadratic | Senza calibration data, applicabile in minuti | Meno maturo come ecosistema |
| SpinQuant | 4 | PTQ + rotation learned (Cayley SGD) | Pesi + attivazioni + KV cache 4-bit | Puo degradare con NVFP4 + RTN standard |
| NVFP4 | 4 | FP4 nativo Blackwell | Hardware acceleration NVIDIA next-gen | Limitato a hardware specifico |
| MXFP4 | 4 | FP4 standard OCP MX | Open standard cross-vendor | Adozione ancora in crescita |

### Visual
- **Descrizione**: la tabella stessa. Aggiungere a destra una piccola legenda con icone: CPU / GPU / NPU / Mobile.
- **Sorgente suggerita**: tabella originale, dati da `deep_dives/quantization.md` + `SOTA_2026.md` §5.

### Speaker notes (180 parole)
Questa e la slide-mappa: serve a darvi il vocabolario per non perdervi in letteratura. Otto nomi, tre famiglie. Famiglia uno: integer quantization tradizionale. GGUF e quello che usate se distribuite su CPU o Apple Silicon: il formato di llama.cpp, quality retention 92%, varianti da Q2_K a Q8_0, sweet spot Q4_K_M. AWQ protegge i pesi salienti guardando le distribuzioni di attivazione: quality 95%, top per instruction-tuned. GPTQ e il piu veloce su GPU NVIDIA con il kernel Marlin, 712 tok/s, ma quality 90%. Famiglia due: aggressive PTQ. AQLM scende sotto i 2 bit per modello con additive quantization. HQQ vi permette di quantizzare in pochi minuti senza calibration set, ottimo per prototipi. SpinQuant aggiunge matrici di rotazione apprese che eliminano gli outlier: ICLR 2025, 4-bit su pesi + attivazioni + KV cache, ma attenzione al trade-off con NVFP4. Famiglia tre: floating-point a bassa precisione. NVFP4 e nativo Blackwell, MXFP4 e lo standard aperto OCP MX. Sono il futuro per hardware nuovo. La regola: scegliete il formato dopo aver fissato il target hardware, non prima.

### Riferimenti
- deep_dives/quantization.md (Formati e metodi a confronto)
- SOTA_2026.md §5
- https://arxiv.org/abs/2405.16406 (SpinQuant)
- https://arxiv.org/abs/2210.17323 (GPTQ)
- https://arxiv.org/abs/2306.00978 (AWQ)

---

## Slide 38 — PTQ vs QAT
**Timing**: 76' cumulativi (00:76-00:78)
**Tipo**: tabella + text

### Headline
PTQ e veloce, QAT e migliore: quando usare cosa

### Sottotitolo
Numeri reali su Gemma 3

### Body (max 40 parole)
PTQ quantizza un modello gia addestrato: minuti, nessun dato di training. QAT incorpora la quantizzazione durante il training: settimane di GPU, ma qualita 54% migliore. Sotto i 4 bit la differenza e dirimente. Apple Foundation Model usa 2-bit QAT.

### Tabella
| Metrica | PTQ | QAT | Differenza |
|---------|-----|-----|------------|
| Perplexity drop | 1.75 punti | 0.8 punti | QAT 54% migliore |
| Accuracy recovery | ~33% | ~67% | QAT 2x migliore |
| GPQA accuracy loss | -1.5% | -0.5% | QAT 3x migliore |
| Tempo applicazione | minuti | settimane di training | PTQ ordini di grandezza piu veloce |
| Richiede training data | No | Si | PTQ utilizzabile su modelli proprietari |

### Visual
- **Descrizione**: due grafici a barre side-by-side. (1) Perplexity drop: PTQ 1.75 vs QAT 0.8. (2) Time-to-apply: PTQ ~minuti vs QAT ~settimane (asse log).
- **Sorgente suggerita**: dati da `deep_dives/quantization.md` (Confronto QAT vs PTQ - dati reali Gemma 3).

### Speaker notes (180 parole)
Domanda pratica che riceverete sempre: "uso PTQ o QAT?". La risposta dipende da due cose: di chi e il modello e a che bit-rate volete arrivare. Se quantizzate un modello proprietario di terzi, QAT non e nemmeno un'opzione: non avete il training set ne accesso al loop di addestramento, quindi PTQ. Se siete voi a fare training (es. fine-tuning di Gemma o Llama), e scendete sotto i 4 bit, QAT vale ogni euro di GPU che vi costa. I numeri di Gemma 3 sono eloquenti: PTQ a 4-bit perde 1.75 punti di perplexity, QAT solo 0.8. Su GPQA, QAT perde tre volte meno accuracy. La accuracy recovery rate e doppia. Apple ha scelto la strada estrema: 2-bit QAT con scaling adattivo ed EMA smoothing per il modello on-device. A 2 bit nativi, PTQ collassa, QAT e l'unico modo. Per i mortali: se trovate un modello con versione QAT ufficiale (Gemma 3 ha pubblicato i QAT su Hugging Face, Gemma 4 segue), sceglietela sempre. Se non c'e, GGUF Q4_K_M e il default ragionevole.

### Riferimenti
- deep_dives/quantization.md (PTQ vs QAT)
- SOTA_2026.md §2.2 (Apple 2-bit QAT)
- https://huggingface.co/google/gemma-3-4b-it-qat-q4_0-gguf

---

## Slide 39 — BitNet b1.58 2B4T
**Timing**: 78' cumulativi (00:78-00:80)
**Tipo**: numbers + text

### Headline
1.58 bit nativi: 0.4 GB di RAM, 45 tok/s su CPU ARM

### Sottotitolo
Microsoft, aprile 2026: smartphone 4 GB senza offloading

### Body (max 40 parole)
Primo modello 1.58-bit nativo a scala 2B, training su 4T token. Memoria 0.4 GB (vs 1.4-4.8 GB di Phi-3 Mini comparabili). Velocita ARM CPU (M2): ~45 tok/s in CPU-only. Energia ARM -55-70%. Deployment su smartphone 4 GB senza offloading.

### Tabella
| Metrica | BitNet b1.58 2B4T | Phi-3 Mini (4-bit) |
|---------|-------------------|--------------------|
| Bit per peso | 1.58 (nativi) | 4 |
| Footprint memoria | 0.4 GB | 1.4-4.8 GB |
| Throughput ARM CPU (M2) | ~45 tok/s | 5-10 tok/s |
| Speedup ARM | 1.37-5.07x baseline | baseline |
| Riduzione energia ARM | 55-70% | baseline |
| Smartphone 4 GB | Si (no offload) | No |

### Visual
- **Descrizione**: due grafici affiancati. (1) Memoria GB: BitNet 0.4, Phi-3 Mini 1.4-4.8 (range). (2) Throughput tok/s su M2: BitNet 45, Phi-3 Mini 5-10.
- **Sorgente suggerita**: dati da SOTA_2026.md §5.2; paper https://arxiv.org/abs/2504.12285.

### Speaker notes (180 parole)
BitNet e l'esperimento che ha dato risultati piu sorprendenti del 2025-2026. L'idea: invece di addestrare in FP16 e quantizzare a 4-bit dopo, addestrare nativamente con pesi ternari (-1, 0, +1), che sono 1.58 bit di entropia. Microsoft ha rilasciato la versione 2B4T - 2 miliardi di parametri, 4 trilioni di token di training - ad aprile 2026. I numeri sono questi: footprint 0.4 GB, ovvero 4-12 volte meno di un comparabile Phi-3 Mini quantizzato. Throughput su M2 in CPU-only: 45 tok/s, contro 5-10 di Phi-3 Mini. Speedup ARM da 1.37x a 5.07x, energia ridotta del 55-70%. La conseguenza pratica e enorme: significa che modelli da 2 miliardi di parametri girano sui telefoni da 4 GB di RAM senza offloading su disco. Microsoft ha rilasciato bitnet.cpp come framework di riferimento (ACL 2025): un BitNet 100B su singola CPU consumer fa 5-7 tok/s. La domanda aperta e se il quality gap rispetto a 4-bit FP sia chiuso davvero per task complessi: i benchmark del paper dicono di si su MMLU/HellaSwag, ma serviranno verifiche indipendenti.

### Riferimenti
- https://arxiv.org/abs/2504.12285 (BitNet b1.58 2B4T)
- https://huggingface.co/microsoft/bitnet-b1.58-2B-4T
- https://github.com/microsoft/BitNet
- SOTA_2026.md §5.2

---

## Slide 40 — NanoQuant: sub-1-bit
**Timing**: 80' cumulativi (00:80-00:82)
**Tipo**: numbers + text

### Headline
Llama2-70B da 138 GB a 5.35 GB

### Sottotitolo
Primo PTQ a livello binario e sub-1-bit, testato su Jetson TX2

### Body (max 40 parole)
Febbraio 2026. Fattorizzazione binaria a basso rango ottimizzata via ADMM. Llama2-70B passa da 138 GB a 5.35 GB con 20.11 tok/s su GPU consumer 8 GB. Llama2-7B compresso in <3 ore su 1 H100 (vs 1+ giorno per AQLM). Testato su NVIDIA RTX 3050 e Jetson TX2.

### Tabella
| Modello | Originale (FP16) | NanoQuant | Riduzione | Throughput |
|---------|------------------|-----------|-----------|------------|
| Llama2-70B | 138 GB | 5.35 GB | 96% | 20.11 tok/s su GPU consumer 8 GB |
| Llama2-7B | ~14 GB | sub-1-bit equiv. | n.d. | <3h compression su 1 H100 |

### Visual
- **Descrizione**: barra orizzontale comparativa. Llama2-70B FP16 138 GB vs NanoQuant 5.35 GB. Sotto, badge "testato su Jetson TX2 + RTX 3050".
- **Sorgente suggerita**: dati da SOTA_2026.md §5.3, paper https://arxiv.org/abs/2602.06694.

### Speaker notes (180 parole)
Se BitNet e l'esperimento piu sorprendente del lato training-time, NanoQuant e quello del lato post-training. E il primo PTQ che scende sotto 1 bit per parametro mantenendo qualita utilizzabile. Tecnica: fattorizzazione binaria a basso rango ottimizzata via ADMM, un solver di programmazione vincolata. Il numero da ricordare: Llama2-70B passa da 138 GB a 5.35 GB - una riduzione del 96%. Il throughput su GPU consumer da 8 GB e 20.11 tok/s, che vuol dire un modello da 70 miliardi di parametri che gira su un laptop gaming. Per Llama2-7B la compressione richiede meno di 3 ore su una singola H100, contro un giorno e oltre di AQLM su A100. Il paper testa su RTX 3050 e Jetson TX2, hardware che e gia in mano a chi sviluppa per edge e robotica. Caveat onesto: NanoQuant esiste solo da febbraio 2026, le repliche indipendenti su altri model family sono ancora limitate. Pero il vettore di ricerca e chiaro: la combinazione BitNet (training nativo) + NanoQuant (PTQ aggressivo) sta spostando il limite di cosa puo girare on-device di un ordine di grandezza all'anno.

### Riferimenti
- https://arxiv.org/abs/2602.06694 (NanoQuant)
- SOTA_2026.md §5.3

---

## Slide 41 — MLPerf Inference v6.0
**Timing**: 82' cumulativi (00:82-00:84)
**Tipo**: text + tabella

### Headline
1 aprile 2026: il benchmark che fa testo

### Sottotitolo
Edge object-detection nuovo task, MLPerf Mobile sub-suite in update

### Body (max 40 parole)
MLPerf Inference v6.0, MLCommons. Aggiornamento piu significativo nella storia del benchmark: nuovi task text-to-video, GPT-OSS 120B, DLRMv3, vision-language, YOLOv11. Nuovo test object-detection per edge systems. MLPerf Mobile sub-suite in aggiornamento per task NLP e LLM on-device.

### Tabella
| Novita v6.0 | Categoria |
|-------------|-----------|
| Text-to-video | Generative |
| GPT-OSS 120B | LLM open |
| DLRMv3 | Recommendation |
| Vision-language | Multimodal |
| YOLOv11 | Object detection (server) |
| Object-detection per edge systems | Edge / mobile |
| Update MLPerf Mobile (NLP, LLM on-device) | Mobile sub-suite |

### Visual
- **Descrizione**: timeline + tabella sopra. Cerchio "1 apr 2026" come marker.
- **Sorgente suggerita**: https://mlcommons.org/2026/04/mlperf-inference-v6-0-results/.

### Speaker notes (180 parole)
MLCommons ha rilasciato MLPerf Inference v6.0 il primo aprile 2026 - non e uno scherzo, e il release ufficiale. Questo e considerato l'aggiornamento piu significativo nella storia del benchmark, perche allinea finalmente il portfolio di task ai workload reali del 2026. Sul fronte server hanno aggiunto text-to-video, GPT-OSS 120B come reference per LLM open di grande taglia, DLRMv3 per i recommender system aggiornati, un task vision-language proper, YOLOv11. Per noi che parliamo di mobile, le due novita rilevanti sono: il nuovo task object-detection per edge systems, che esce dal solo image classification e finalmente misura un compito che ha senso su drone/auto/telefono; e l'update annunciato per MLPerf Mobile sub-suite, che ora include task NLP e LLM on-device. Quest'ultimo e l'awaited piece: per la prima volta avremo metriche standardizzate cross-vendor per LLM su smartphone. Quando i risultati definitivi della sub-suite mobile saranno pubblicati, sara il primo modo serio di confrontare A19 Pro vs Snapdragon 8 Elite Gen 5 vs Tensor G5 su LLM, senza dover credere ai marketing claim dei vendor.

### Riferimenti
- https://mlcommons.org/2026/04/mlperf-inference-v6-0-results/
- SOTA_2026.md §10.1

---

## Slide 42 — Throughput reali per device
**Timing**: 84' cumulativi (00:84-00:86)
**Tipo**: tabella

### Headline
Quanti token al secondo, su che cosa, davvero

### Sottotitolo
Cortex-A76 / X4 / Snapdragon 8 Elite / A19 Pro / M5 / BitNet

### Body (max 40 parole)
Numeri di decode reali ad aprile 2026 da fonti pubbliche (Argmax, llmcheck.net, paper). Attenzione a leggere modello + framework: 31 tok/s su MLX e 136 tok/s su Cactus sullo stesso A19 Pro non sono confrontabili senza specificare il setup.

### Tabella
| Setup | Tok/s decode | Note |
|-------|--------------|------|
| Cortex-A76/A77 CPU | 2-4 | llama.cpp baseline |
| Cortex-X4 CPU | 8-15 | Armv9-A |
| Snapdragon 8 Elite Hexagon NPU | ~70 | LiteRT, modello quantizzato |
| iPhone 17 Pro (A19 Pro), MLX | 31-60 | LFM2.5 1.2B / Gemma 4 E2B |
| iPhone 17 Pro (A19 Pro), Cactus framework | 136 | ~3 B modello |
| iPad Pro M5, MLX | 1.2-2.2x iPhone 17 Pro | Memory bandwidth driven |
| BitNet 2B su ARM CPU M2 | ~45 | CPU-only, 1.58-bit |
| Gemma 3 1B Q4 GPU mobile | >2.500 | Throughput marketing (peak) |

### Visual
- **Descrizione**: bar chart orizzontale ordinato per tok/s, con due colori distinti per "framework MLX/native" vs "marketing peak". Asse log per gestire il range 2-2500.
- **Sorgente suggerita**: dati da SOTA_2026.md §10.2; fonti https://www.argmaxinc.com/blog/iphone-17-on-device-inference-benchmarks e https://llmcheck.net/benchmarks.

### Speaker notes (200 parole)
Chiudiamo il blocco con i numeri che vorrete citare a casa. Tre avvertenze prima di leggere la tabella. Prima: tok/s decode e diversa da tok/s prefill - quella che vedete qui e la velocita di generazione, non di lettura del prompt. Seconda: il framework conta quanto il chip. Sull'iPhone 17 Pro abbiamo 31 tok/s con MLX di Apple e 136 tok/s con il framework Cactus, sullo stesso A19 Pro: e una differenza di 4x dovuta al runtime, non al silicio. Terza: i numeri marketing tipo "2500 tok/s su Gemma 3 1B Q4" sono peak teorici, non sostenuti, e si riferiscono a configurazioni GPU mobile estreme. La tabella in pratica vi dice questo: una CPU ARM mainstream da telefono di 3-4 anni fa (Cortex-A76) fa 2-4 tok/s ed e poco piu di un esperimento. Una CPU di punta attuale (Cortex-X4) fa 8-15 tok/s, usabile per chat. La NPU dedicata (Hexagon su Snapdragon 8 Elite) sale a 70 tok/s, qui inizia il regime dove l'utente non aspetta. L'iPhone 17 Pro con MLX e nel range 31-60 tok/s, allineato al competitor Android di fascia alta. iPad Pro M5 con piu memory bandwidth fa 1.2-2.2x l'iPhone, conferma che oltre il chip conta la banda. BitNet 2B fa 45 tok/s in CPU-only puro: vuol dire che funziona anche su device senza NPU dedicata.

### Riferimenti
- https://www.argmaxinc.com/blog/iphone-17-on-device-inference-benchmarks
- https://llmcheck.net/benchmarks
- SOTA_2026.md §10.2
- https://xumengwei.github.io/files/ASPLOS25-NPU.pdf (energia NPU vs CPU)


---

# Blocco 6-7 — Demo live e Chiusura (slide 43-59)

## Slide 43 — Demo setup: hardware e configurazione
**Timing**: min 70-72
**Tipo**: tabella

### Headline
Cosa serve per replicare la demo a casa
### Sottotitolo
Hardware minimo, dispositivi target e backup video pre-registrato

### Body
Apple Intelligence richiede iPhone 15 Pro o superiore con 8 GB di RAM. ML Kit GenAI gira su Pixel 9/10 con AICore abilitato. Il Mac M2+ serve per Xcode 17 e per il Simulator iOS 26.

### Tabella
| Item | Specifica |
|------|-----------|
| Mac (sviluppo Apple) | Apple Silicon M2/M3 + Xcode 17 + Simulator iOS 26 |
| iPhone reale | iPhone 15 Pro o successivo, Apple Intelligence abilitato |
| Android | Pixel 9 / Pixel 10 (AICore + Gemini Nano 4) |
| Cavi e dock | USB-C, Lightning, dock USB, HDMI per proiettore |
| Backup | Video pre-registrato delle 6 demo (fallback se rete o NPU falliscono) |

### Visual
- **Descrizione**: Foto/render dei tre dispositivi (MacBook, iPhone 17 Pro, Pixel 10) affiancati con etichette delle specifiche chiave (RAM, NPU TOPS).
- **Sorgente suggerita**: Composizione manuale; immagini ufficiali Apple/Google product page.

### Speaker notes
Apriamo il blocco demo con il setup. Voglio essere trasparente: questo non gira su qualunque telefono. Apple Intelligence richiede iPhone 15 Pro o successivo per via degli 8 GB di RAM minimi, mentre ML Kit GenAI Summarization e Prompt API richiedono Pixel 9 o 10 con AICore abilitato dalle Developer Options. Sul Mac uso Xcode 17 con il Simulator iOS 26 per la parte di guided generation, e collego l'iPhone fisico via USB-C per mostrare la latenza reale on-device. Tengo sempre un backup video pre-registrato delle stesse demo, perche' due cose possono andare storte: la rete WiFi della sala (anche se on-device, alcune API hanno una prima inizializzazione che scarica asset) e il throttling termico se il dispositivo era gia' caldo. Negli ultimi tre seminari il backup video l'ho usato una volta sola, ma non voglio rischiare di bruciare 15 minuti se qualcosa va storto. Ricordatevi: in uno scenario di produzione, dovete sempre avere un fallback graceful.

### Riferimenti
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SEMINAR.md (sezione 6.1)
- https://developer.apple.com/documentation/FoundationModels

---

## Slide 44 — Demo Swift parte 1: chat semplice
**Timing**: min 72-74
**Tipo**: code

### Headline
LanguageModelSession — la chat in 4 righe
### Sottotitolo
Una sessione, un prompt, una risposta — tutto on-device

### Body
La chat minima Apple Foundation Models e' letteralmente quattro righe. La sessione mantiene il contesto, respond(to:) e' async/await, l'output e' un wrapper structured con .content per il testo grezzo.

### Codice
```swift
import FoundationModels

// 1. Chat semplice
let session = LanguageModelSession()
let r = try await session.respond(
    to: "Spiega in 2 frasi cosa fa il Neural Engine."
)
print(r)
```

### Visual
- **Descrizione**: Screenshot Xcode con il codice a sinistra e la console output a destra che mostra una risposta tipo "Il Neural Engine e' un acceleratore dedicato per reti neurali...". Highlight sul tempo di risposta sotto i 100 ms.
- **Sorgente suggerita**: Screenshot reale catturato durante prova, oppure mockup Xcode Light theme.

### Speaker notes
Partiamo dal caso piu' semplice possibile: una chat one-shot. Notate tre cose. Primo: non ho passato ne' API key ne' endpoint, perche' il modello e' gia' sul dispositivo, non c'e' nulla da autenticare. Secondo: LanguageModelSession senza configuration usa le instructions di default e il modello on-device da circa 3 miliardi di parametri quantizzato a 2 bit. Terzo: respond(to:) ritorna un oggetto Response, non una String, perche' Apple ha previsto fin dall'inizio che le risposte possano essere structured (lo vediamo tra una slide). Sull'iPhone 17 Pro questa chiamata risponde in circa 60-80 millisecondi al primo token, e poi streamma a circa 30-60 token al secondo a seconda del prompt. Per chi viene dal cloud OpenAI, la differenza piu' sorprendente e' che potete chiamare questa funzione in airplane mode e funziona uguale. Demo dal vivo ora: lancio l'app, premo invio, vedete il risultato.

### Riferimenti
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SEMINAR.md (sezione 6.2 step 1)
- /Users/giadafranceschini/code/ai_foundation_model_mobile/examples/ios/BasicChat.swift
- https://developer.apple.com/documentation/FoundationModels

---

## Slide 45 — Demo Swift parte 2: guided generation con @Generable
**Timing**: min 74-76
**Tipo**: code

### Headline
Output strutturato garantito con @Generable
### Sottotitolo
Niente piu' parsing JSON fragile — il compilatore Swift e' la tua validazione

### Body
@Generable trasforma una struct Swift in uno schema vincolante per il modello. @Guide aggiunge constraint semantici (max caratteri, anyOf, descrizione). Il compilatore garantisce che l'output rispetti il tipo.

### Codice
```swift
@Generable
struct ConceptCard {
    @Guide(description: "Titolo del concetto, max 60 caratteri")
    var title: String

    @Guide(.anyOf(["base", "intermedio", "avanzato"]))
    var level: String

    @Guide(description: "Spiegazione in massimo 3 frasi")
    var explanation: String
}

let card = try await session.respond(
    to: "Crea una scheda concetto per: quantizzazione 4-bit",
    generating: ConceptCard.self
)
```

### Visual
- **Descrizione**: Diagramma split: a sinistra il blocco struct Swift, al centro una freccia "constrained decoding", a destra una scheda UI renderizzata con i tre campi popolati (title: "Quantizzazione 4-bit", level: "intermedio", explanation: "...").
- **Sorgente suggerita**: Mockup ad hoc o screenshot reale di un'app SwiftUI semplice.

### Speaker notes
Questa e' la feature che cambia il modo di pensare alle integrazioni LLM. Nel mondo cloud, per ottenere JSON strutturato dovete fare prompt engineering, sperare che il modello rispetti lo schema, e poi parserare con try/catch. Apple ha integrato il constrained decoding direttamente nel runtime: il modello non puo' generare token che violano lo schema della struct. @Guide aggiunge vincoli semantici: .anyOf forza un enum, le description guidano il modello su lunghezza e contenuto. Il vantaggio non e' solo developer experience: e' che potete usare gli LLM on-device come componente affidabile di un pipeline tipato, non come "magic box" da cui sperare risposte ragionevoli. Mostro ora la generazione live: lancio il prompt, il modello impiega circa 200 ms per produrre la struct intera con i tre campi popolati. Notate che explanation rispetta il limite di 3 frasi senza che io abbia dovuto verificarlo.

### Riferimenti
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SEMINAR.md (sezione 6.2 step 2)
- https://developer.apple.com/documentation/FoundationModels

---

## Slide 46 — Demo Swift parte 3: tool calling con WeatherTool
**Timing**: min 76-78
**Tipo**: code

### Headline
Tool protocol — il modello chiama il tuo codice
### Sottotitolo
Conform a Tool, dichiara gli Arguments, implementa call() — l'orchestrazione la fa il framework

### Body
Il Tool protocol Apple e' tre membri: name, description, call(arguments:). Gli Arguments sono a loro volta @Generable, quindi il modello sa come compilarli. Passi i tool al constructor della session.

### Codice
```swift
struct WeatherTool: Tool {
    let name = "getWeather"
    let description = "Restituisce il meteo di una citta'"

    @Generable
    struct Arguments { var city: String }

    func call(arguments: Arguments) async throws -> String {
        "A \(arguments.city) ci sono 22 C e sole."
    }
}

let s2 = LanguageModelSession(tools: [WeatherTool()])
let r2 = try await s2.respond(to: "Che tempo fa a Bologna?")
```

### Visual
- **Descrizione**: Sequence diagram: User prompt -> LanguageModelSession -> decide tool call -> WeatherTool.call(city: "Bologna") -> result -> session compone risposta finale -> user.
- **Sorgente suggerita**: Mermaid sequenceDiagram o disegno ad hoc.

### Speaker notes
Arriviamo al pattern agentico. Il Tool protocol e' la primitiva con cui il modello on-device puo' chiamare il vostro codice Swift: API REST, SQLite, HealthKit, qualsiasi cosa. Notate la simmetria: gli Arguments sono @Generable, esattamente come la ConceptCard di prima. Questo significa che il framework usa lo stesso meccanismo di constrained decoding per garantire che la chiamata al tool sia ben formata. La call() e' async, quindi potete fare I/O senza bloccare. Il flusso e' completamente trasparente per l'utente finale: il modello decide se invocare il tool basandosi sulla description, esegue la chiamata, riceve il risultato, e poi formula la risposta in linguaggio naturale. Questo e' il foundation block per costruire agenti on-device: aggiungete piu' tool, e ottenete un agente ReAct che puo' interagire con il sistema operativo, con i contatti, con la rubrica. Demo live: chiedo "che tempo fa a Bologna", e nei log vedete due round trip - tool call e response composition.

### Riferimenti
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SEMINAR.md (sezione 6.2 step 3)
- /Users/giadafranceschini/code/ai_foundation_model_mobile/examples/ios/ToolCallingExample.swift

---

## Slide 47 — Demo Swift BACKUP: output atteso e fallback
**Timing**: min 78-79
**Tipo**: text

### Headline
Cosa dovreste vedere se la demo funziona
### Sottotitolo
Output testuale atteso + screenshot pre-registrati per ogni step

### Body
Slide tenuta in tasca. Se Xcode crasha, Apple Intelligence non e' disponibile, o la console non e' leggibile dal proiettore, mostro questo riassunto e passo oltre senza perdere tempo.

### Tabella output atteso
| Step | Prompt | Output atteso (sintetico) |
|------|--------|---------------------------|
| 1. Chat | "Spiega in 2 frasi cosa fa il Neural Engine." | "Il Neural Engine e' un acceleratore hardware dedicato a reti neurali integrato negli SoC Apple. Permette di eseguire inferenza ML con consumo energetico molto inferiore alla CPU/GPU." (~60 token, ~80 ms TTFT) |
| 2. Guided | "Crea scheda concetto: quantizzazione 4-bit" | ConceptCard(title: "Quantizzazione 4-bit", level: "intermedio", explanation: "Tecnica che riduce ogni peso da 32 a 4 bit. Diminuisce 8x la memoria con perdita minima di qualita'. Standard per LLM mobile.") |
| 3. Tool | "Che tempo fa a Bologna?" | Tool log: getWeather(city: "Bologna"). Risposta finale: "A Bologna oggi ci sono 22 gradi e cielo sereno." |

### Visual
- **Descrizione**: Tre screenshot Xcode pre-catturati (chat, guided, tool) in layout 3x1, con didascalie. Pre-seminario: catturare con dispositivo reale e luce buona.
- **Sorgente suggerita**: Catturare prima del seminario su iPhone 17 Pro reale + Xcode 17.

### Speaker notes
Slide di sicurezza. Se la demo dal vivo non parte - perche' il proiettore non riconosce il telefono, perche' Apple Intelligence non e' attivo sul device del laboratorio, perche' iOS ha deciso di rifare il download del modello - mostro questa slide, leggo gli output attesi, e il messaggio passa lo stesso. Pre-seminario devo: 1) catturare gli screenshot Xcode con dispositivo reale, non simulatore; 2) registrare un video di backup di tutta la demo Swift (3-4 minuti), salvarlo localmente e su Drive; 3) testare il proiettore HDMI con il Mac il giorno prima. Regola d'oro: una demo che funziona e' magia, una demo che fallisce e' un disastro - quindi la slide backup deve essere altrettanto leggibile e didattica, non solo un'ammissione di sconfitta. Se serve, faccio walkthrough del codice riga per riga partendo da questa slide.

### Riferimenti
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SEMINAR.md (sezione 6.4 piano B)

### Backup
Output testuali sopra. Screenshot da catturare pre-seminario su iPhone 17 Pro + Xcode 17 console.

---

## Slide 48 — Demo Kotlin parte 1: ML Kit Summarization
**Timing**: min 79-81
**Tipo**: code

### Headline
ML Kit GenAI Summarization — task-specific, GA su Android
### Sottotitolo
Niente prompt engineering: una API dedicata per riassumere

### Body
ML Kit GenAI offre quattro API task-specific in GA: Summarization, Rewriting, Proofreading, Image Description. Costruisci con Builder, scegli output type (ONE_BULLET, THREE_BULLETS, ONE_HEADLINE), chiami runInference().

### Codice
```kotlin
// 1. ML Kit GenAI Summarization
val summarizer = Summarization.getClient(
    SummarizerOptions.builder(context)
        .setOutputType(SummarizerOptions.OutputType.ONE_BULLET)
        .build()
)
val summary = summarizer.runInference(longArticle).get()
```

### Visual
- **Descrizione**: Mockup app Android con un articolo lungo a sinistra e il bullet di riassunto generato a destra; etichetta "on-device, no network". Indicatore di latenza tipo "~500 ms".
- **Sorgente suggerita**: Android Studio Layout Inspector o mockup Figma.

### Speaker notes
Cambio ecosistema: Android. Google ha fatto una scelta filosofica diversa da Apple. Invece di esporre direttamente un LanguageModelSession generica, ML Kit GenAI offre quattro API task-specific in GA: Summarization, Rewriting, Proofreading, Image Description. Il vantaggio per il developer e' enorme: zero prompt engineering, zero rischio di output strani, latenza prevedibile. Lo svantaggio e' meno flessibilita': se il vostro task non rientra in una delle quattro categorie, dovete scendere a Prompt API (slide successiva). Notate il pattern Builder, molto idiomatico Android. OutputType.ONE_BULLET produce un bullet single-line; ci sono anche THREE_BULLETS e ONE_HEADLINE. Sotto il cofano gira Gemini Nano 4 (basato su Gemma 4 E2B) tramite AICore. Il primo runInference() puo' impiegare 1-2 secondi per il warm-up del modello in memoria; le chiamate successive sono nell'ordine dei 300-500 ms per articoli da qualche centinaio di parole. Demo live: incollo un articolo Wikipedia e mostro il bullet.

### Riferimenti
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SEMINAR.md (sezione 6.3 step 1)
- /Users/giadafranceschini/code/ai_foundation_model_mobile/examples/android/MediaPipeLLMExample.kt
- https://developer.android.com/ai/gemini-nano/ml-kit-genai

---

## Slide 49 — Demo Kotlin parte 2: Prompt API + FunctionGemma stub
**Timing**: min 81-83
**Tipo**: code

### Headline
Prompt API free-form e FunctionGemma 270M
### Sottotitolo
Quando le 4 API non bastano: prompt arbitrario + function calling specializzato

### Body
Prompt API (`GenerativeModel`) e' il free-form prompt su Gemini Nano 4. Per esporre/orchestrare funzioni ad agenti AI Android offre **AppFunctions** (`android.app.appfunctions`, API 36 / Android 16). FunctionGemma 270M va caricato come modello via **LiteRT-LM** o Google AI Edge Gallery — non c'e' una classe `FunctionAgent` ufficiale.

### Codice
```kotlin
// 2. Prompt API (free-form, AICore)
val genAi = GenAi.getClient(GenAiOptions.builder(context).build())
val out = genAi.runInference(
    "Spiega in italiano cosa fa LiteRT-LM in 3 punti."
).get()

// 3. AppFunctions: esporre una funzione invocabile da agenti AI (Android 16, API 36)
//    Documentazione: https://developer.android.com/ai/appfunctions
@AppFunctionSerializable
data class WeatherArgs(val city: String)

class WeatherFunctions : AppFunctionService() {
    @AppFunction
    fun getWeather(args: WeatherArgs): String =
        "A ${args.city} ci sono 22 C e sole."
}

// 4. FunctionGemma 270M caricato via LiteRT-LM (modello, non SDK)
//    Repo HuggingFace: google/functiongemma-270m-it
//    Pipeline: scaricamento .litert -> LiteRT-LM Engine -> tool selection
```

### Visual
- **Descrizione**: Diagramma a due colonne. Sinistra: Prompt API (`GenerativeModel.startChat`) -> Gemini Nano 4 -> output testo. Destra: AppFunctions (`@AppFunction` registrate dall'app) + FunctionGemma 270M caricato via LiteRT-LM -> selezione tool + argomenti -> esecuzione `AppFunctionService` -> risposta. Etichetta "FunctionGemma 270M: 85% accuracy Mobile Actions".
- **Sorgente suggerita**: Disegno ad hoc Mermaid o vector custom.

### Speaker notes
Due API, due use case diversi. Prompt API e' il free-form: passate qualsiasi prompt a `GenerativeModel.startChat()` e Gemini Nano 4 risponde — equivalente Android di `LanguageModelSession`. Sul lato function calling il quadro e' meno omogeneo. Su Android la primitiva ufficiale per esporre funzioni invocabili da agenti AI e' **AppFunctions**, package `android.app.appfunctions`, introdotta in Android 16 (API level 36): annotate i metodi con `@AppFunction` ed estendete `AppFunctionService`. FunctionGemma 270M non ha un'API SDK chiamata `FunctionAgent` (avevo scritto uno stub fittizio in una versione precedente — corretto): e' un modello pesi-aperti distribuito via HuggingFace e caricato in app via **LiteRT-LM** o tramite l'AI Edge Gallery. Pattern realistico: AppFunctions come superficie di registrazione/discovery delle azioni, FunctionGemma come modello di selezione tool, Gemini Nano 4 come ragionatore. Vincoli: AppFunctions richiede Android 16+ e ha rate limit sull'invocazione cross-app. FunctionGemma 270M gira su device entry-level grazie ai 270M parametri.

### Riferimenti
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SEMINAR.md (sezione 6.3 step 2-3)
- /Users/giadafranceschini/code/ai_foundation_model_mobile/examples/android/FunctionCallingExample.kt
- https://developer.android.com/ai/appfunctions
- https://developer.android.com/reference/android/app/appfunctions/package-summary
- https://blog.google/technology/developers/functiongemma/
- https://huggingface.co/google/functiongemma-270m-it

---

## Slide 50 — Demo Kotlin BACKUP: output atteso e piano B
**Timing**: min 83-84
**Tipo**: text

### Headline
Output atteso Kotlin + piano B se Pixel non risponde
### Sottotitolo
Fallback Xcode Playground per Foundation Models e AI Studio web per Gemini

### Body
Se il Pixel non ha AICore aggiornato o ML Kit GenAI ritorna NOT_AVAILABLE, mostro questo summary e passo a piano B: Xcode Playground locale (Apple) o AI Studio web (Google, con disclaimer "non e' on-device").

### Tabella output atteso
| Step | Input | Output atteso |
|------|-------|---------------|
| 1. Summarization | Articolo Wikipedia 800 parole su LiteRT-LM | "- LiteRT-LM e' il runtime cross-platform di Google per LLM on-device, sostituisce MediaPipe LLM e supporta Android/iOS/web." |
| 2. Prompt API | "Spiega LiteRT-LM in 3 punti" | "1) Runtime cross-platform unificato. 2) Supporta Gemma 4 E2B/E4B con quantizzazione INT4. 3) Backend Hexagon NPU su Snapdragon, GPU Mali su Tensor." |
| 3. FunctionGemma | "Che tempo fa a Bologna?" | Tool selected: getWeather, args: {city: "Bologna"}. Risposta finale composta dal modello caller. |

### Piano B fallback
- **Apple**: Xcode Playground per Foundation Models nel Simulator iOS 26 (gira su Mac M2+ senza iPhone fisico).
- **Google**: AI Studio web (https://aistudio.google.com) con stesso prompt sui modelli cloud. Disclaimer esplicito: "non e' on-device, e' solo per illustrare il pattern; latenza e privacy sarebbero diverse".

### Visual
- **Descrizione**: Tre screenshot Android Studio + emulator pre-catturati (summarization, prompt, function call), layout 3x1. Quarto screenshot mini in basso: AI Studio web con disclaimer rosso "fallback only".
- **Sorgente suggerita**: Catturare pre-seminario su Pixel 10 reale + Android Studio.

### Speaker notes
Stesso pattern di sicurezza della slide 47. Se il Pixel non collabora, ho due opzioni: opzione A elegante - Xcode Playground per Foundation Models, che gira nel Simulator iOS 26 sul Mac senza bisogno di iPhone fisico, ma e' Apple, quindi mostra solo la parte iOS; opzione B realistica - apro AI Studio web e mostro lo stesso prompt sui modelli cloud Google, dichiarando esplicitamente "non e' on-device, e' solo per illustrare lo schema". Quest'ultima opzione e' quella menzionata in SEMINAR.md sezione 6.4. Pre-seminario devo: catturare i tre screenshot Android, registrare video backup completo della demo Kotlin, verificare che AICore sia aggiornato sul Pixel di test, e salvare un secondo Pixel di backup con configurazione gia' testata. Suggerimento didattico: anche se la demo va male, la slide backup permette di discutere "perche' on-device a volte fallisce in laboratorio" - tema interessante di per se'.

### Riferimenti
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SEMINAR.md (sezione 6.4 piano B)

### Backup
Output testuali sopra. Screenshot pre-catturati. URL fallback: https://aistudio.google.com.

---

## Slide 51 — Decision matrix iOS vs Android per scenario
**Timing**: min 84-86
**Tipo**: tabella

### Headline
Quale ecosistema per quale scenario
### Sottotitolo
Privacy app, productivity, gaming, accessibility — quattro classi, due risposte

### Body
Non c'e' un vincitore universale. Apple vince su privacy/UX coerente, Google su flessibilita' modelli e function calling specializzato. La scelta dipende da target demografico, budget hardware e ambizione agentica.

### Tabella
| Scenario | iOS (Apple FM) | Android (Gemma 4 + ML Kit) | Vincitore |
|----------|----------------|----------------------------|-----------|
| Privacy app (es. journaling, salute mentale) | Foundation Models GA, Private Cloud Compute, no telemetria opt-out | LiteRT-LM locale, Private Compute Core, ma device fragmentation | **iOS** |
| Productivity (riassunti, riscrittura, traduzione) | @Generable + Tool protocol, ottimo SwiftUI integration | ML Kit GenAI 4 API task-specific GA, zero prompt engineering | **Android** (per APIs dedicate) |
| Gaming (NPC, dialoghi dinamici) | Latenza minima su A19/M5 (~30-60 tok/s MLX) | Tensor G5 + Snapdragon 8 Elite, throughput simile | **Pari** |
| Accessibility (image description, ASR offline) | Image description via Vision + FM, Whisper via ExecuTorch | ML Kit Image Description GA + Gemma 4 multimodale audio | **Android** (multimodale audio nativo) |

### Visual
- **Descrizione**: Matrice 4x3 con celle colorate (verde/giallo/rosso) e icone (lock, bolt, gamepad, accessibility). Colonna "vincitore" in evidenza.
- **Sorgente suggerita**: Tabella ad hoc.

### Speaker notes
Questa e' la slide che gli studenti vorranno fotografare. Quattro scenari rappresentativi, e per ognuno la mia opinione tecnica su quale ecosistema scegliere oggi - aprile 2026. Privacy app: Apple vince per la combinazione di FM GA stabile, Private Cloud Compute trasparente e meno telemetria di default. Productivity: Android vince paradossalmente proprio perche' meno flessibile - le quattro API ML Kit GenAI in GA risolvono il 70% dei task productivity senza prompt engineering, mentre su iOS dovete comunque scrivere prompt dentro LanguageModelSession. Gaming: pari, dipende dal device target reale. Accessibility: Android oggi avanti per via di Gemma 4 con audio multimodale nativo, mentre su iOS dovete combinare Vision + FM + Whisper separati. Importante: queste valutazioni cambieranno tra 12 mesi. WWDC 2026 e Google I/O 2026 ridefiniranno la matrice. Disclaimer: trade-off, non verita'.

### Riferimenti
- /Users/giadafranceschini/code/ai_foundation_model_mobile/comparisons.md
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md

---

## Slide 52 — Quando NON usare on-device: tre anti-pattern
**Timing**: min 86-88
**Tipo**: text

### Headline
Tre casi in cui il cloud rimane la scelta giusta
### Sottotitolo
Modelli grandi, dati cross-user, frequent fine-tuning

### Body
On-device non e' una bacchetta magica. Se il vostro use case rientra in uno di questi tre pattern, il cloud (anche con un costo di inferenza) e' tecnicamente piu' sensato.

### Tre anti-pattern
1. **Modelli grandi (>10B parametri)**. Anche con NanoQuant sub-1-bit Llama 70B sta in 5.35 GB ma e' al limite dei dispositivi 8 GB e ha latenza inaccettabile. Se vi serve qualita' frontier, il cloud non ha alternative.
2. **Dati cross-user**. Se la vostra app deve aggregare/correlare dati di utenti diversi (raccomandazioni collaborative, fraud detection cross-account, social graph analysis), l'on-device per definizione non puo': i dati di altri utenti non sono sul mio telefono.
3. **Frequent fine-tuning / personalizzazione continua**. Se il modello deve essere ri-trainato ogni settimana sui dati aggregati, non potete distribuire un nuovo binario di 2 GB ogni settimana via App Store. LoRA adapters mitigano ma non risolvono. Cloud + RAG + retraining centralizzato resta superiore.

### Visual
- **Descrizione**: Tre card affiancate con icone (size, network, refresh) e una banda rossa "anti-pattern". Sotto, una piccola nota verde: "Tutto il resto: considerare on-device first".
- **Sorgente suggerita**: Layout ad hoc.

### Speaker notes
Antidoto al hype. Vi ho passato 80 minuti a dire "on-device e' magia": ora vi do tre scenari in cui non lo e'. Primo: modelli grandi. NanoQuant fa miracoli, ma sotto 1 bit ci sono limiti di qualita' che non si superano - se vi serve la capacita' di un modello frontier, dovete andare in cloud. Secondo: dati cross-user. Questa e' una limitazione architetturale, non tecnologica - non si risolve mai. Se la vostra app fa raccomandazioni collaborative tipo Spotify, gli embedding degli altri utenti non possono stare sul mio telefono. Cloud obbligatorio. Terzo: frequent fine-tuning. App Store review per un binario aggiornato ogni settimana e' impraticabile. LoRA adapters scaricabili over-the-air aiutano (Apple le supporta in iOS 26 con entitlement dedicato), ma per personalizzazione veramente frequente serve un backend. Regola pratica: on-device per default su tutto cio' che e' personale, monouso, latency-sensitive. Cloud per cio' che e' aggregato, frontier-quality, o ri-trainato spesso. La maggior parte delle app reali sono ibride.

### Riferimenti
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md (sezione quantizzazione, NanoQuant)
- /Users/giadafranceschini/code/ai_foundation_model_mobile/concepts_theory.md

---

## Slide 53 — Numeri reali aprile 2026
**Timing**: min 88-90
**Tipo**: tabella

### Headline
Benchmark pubblici: A19 Pro, iPad Pro M5, Snapdragon 8 Elite
### Sottotitolo
Argmax, llmcheck.net, MLPerf v6.0 — i numeri che potete citare con fonte

### Body
A19 Pro 3.1x rispetto a iPhone 16 Pro su decode (Argmax). iPad Pro M5 1.2-2.2x iPhone 17 Pro grazie a memory bandwidth. BitNet 2B su CPU M2 raggiunge ~45 tok/s senza NPU.

### Tabella throughput decode
| Device / setup | Tok/s | Note | Fonte |
|----------------|-------|------|-------|
| iPhone 17 Pro (A19 Pro), MLX, LFM2.5 1.2B | 31-60 | 3.1x vs iPhone 16 Pro | Argmax |
| iPhone 17 Pro, Cactus framework, ~3B model | 136 | Ottimizzazioni vendor | Cactus |
| iPad Pro M5, MLX | 1.2-2.2x iPhone 17 Pro | Memory bandwidth superiore | llmcheck.net |
| Snapdragon 8 Elite, Hexagon NPU, LiteRT | ~70 | Quantizzato INT4 | LiteRT bench |
| BitNet 2B su ARM CPU M2 | ~45 | CPU-only, 1.58-bit nativi | Microsoft BitNet |
| Energia NPU vs CPU @ 1024 token | 35-60x meno | Vantaggio cresce col context | ASPLOS25 |

### Visual
- **Descrizione**: Bar chart orizzontale dei throughput, ordinato per tok/s. Barra Cactus 136 in evidenza con asterisco "framework vendor-optimized". Logo MLPerf in basso a destra.
- **Sorgente suggerita**: Chart.js o Excel/Numbers.

### Speaker notes
La slide piu' "asciutta" della chiusura, ma anche la piu' citabile. Tutti i numeri hanno fonte pubblica, niente stime mie. Highlight da commentare: A19 Pro fa 3.1x rispetto al modello dell'anno prima - questo e' il salto generazionale sull'NPU, ed e' coerente con quello che Apple ha annunciato a settembre 2025. Cactus framework arriva a 136 tok/s su iPhone 17 Pro: vendor third-party, ottimizzazioni custom, ma dimostra che c'e' headroom oltre quello che Apple espone via FoundationModels framework. iPad Pro M5: 1.2-2.2x iPhone 17 Pro, e il fattore non e' la NPU (simile), e' la memory bandwidth - LLM decode e' memory-bound, non compute-bound. BitNet 2B su CPU senza NPU fa comunque 45 tok/s, dimostrando che la quantizzazione 1.58-bit cambia le regole. Energia: NPU usa 35-60 volte meno energia di CPU su 1024 token - questo significa che batteria e termal sono la vera variabile da monitorare in produzione, non la latenza.

### Riferimenti
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md (sezione 10.2)
- https://www.argmaxinc.com/blog/iphone-17-on-device-inference-benchmarks
- https://llmcheck.net/benchmarks
- https://mlcommons.org/2026/04/mlperf-inference-v6-0-results/

---

## Slide 54 — Cosa proverei domani mattina: tre esercizi
**Timing**: min 90-92
**Tipo**: text

### Headline
Tre esperimenti concreti per iniziare oggi
### Sottotitolo
Da 30 minuti a un weekend — tutti realizzabili con il vostro Mac

### Body
Per fissare quanto visto, tre esperimenti progressivi. Il primo si fa in mezz'ora, l'ultimo in un weekend. Tutti producono qualcosa di mostrabile a un colloquio.

### Tre esercizi
1. **30 minuti — Hello World Foundation Models**. Aprite Xcode 17, create un progetto SwiftUI, copiate i 4 esempi della demo (chat, @Generable, Tool, streaming), provateli nel Simulator iOS 26 o su iPhone 15 Pro+. Output: capirete il developer flow end-to-end.
2. **2-3 ore — Mini-app productivity**. Costruite una app che riassume gli appunti vocali (input: trascrizione, output: bullet points). Su iOS usate Speech framework + LanguageModelSession con @Generable. Su Android usate ML Kit Summarization. Output: prima app utile veramente offline.
3. **Un weekend — Agente personale offline con tool**. Implementate un assistente che usa 3 tool reali: meteo (HTTP), calendario (EventKit/Calendar API), promemoria (UserDefaults/SharedPrefs). Pattern ReAct, memoria episodica in SQLite locale. Output: portfolio piece serio, da mostrare a colloqui.

### Visual
- **Descrizione**: Three-step infographic con timer (30 min, 2-3 h, weekend), icona per ogni esercizio (chat bubble, microfono, robot), e barra di difficolta'.
- **Sorgente suggerita**: Layout ad hoc.

### Speaker notes
Voglio che lasciate la sala con qualcosa da fare lunedi'. Tre esercizi, difficolta' crescente. Il primo e' letteralmente un'ora di lavoro - non c'e' scusa per non farlo. Avete il codice in repo, dovete solo aprire Xcode. Imparerete piu' in 30 minuti di pratica che in 2 ore di teoria. Il secondo e' la prima vera app utile: prendete gli appunti vocali del prof, riassumete in bullet, salvate in Note. Casi d'uso reale, e dimostra che on-device produce valore vero. Il terzo e' il weekend project: un agente con tre tool reali, ReAct loop, memoria persistente. Questo e' un progetto da mettere su GitHub e linkare nel CV - in un mercato del lavoro dove "ho usato l'API di OpenAI" e' diventato banale, "ho costruito un agente che gira offline sul mio iPhone" e' ancora raro e impressionante. Suggerimento bonus: documentate il vostro processo in un blog post. Il rapporto effort/visibilita' e' altissimo perche' l'argomento e' caldo e i contenuti tecnici scarseggiano.

### Riferimenti
- /Users/giadafranceschini/code/ai_foundation_model_mobile/examples/
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SEMINAR.md (slide 43)

---

## Slide 55 — Futuro: WWDC 2026 e Google I/O 2026
**Timing**: min 92-94
**Tipo**: text

### Headline
Cosa aspettarsi nei prossimi 60 giorni
### Sottotitolo
Google I/O 19-20 maggio, WWDC 8-12 giugno — anticipazioni con label "rumor"

### Body
Date confermate ufficialmente: Google I/O 19-20 maggio 2026 (Shoreline Amphitheatre, Mountain View + livestream); Apple WWDC 8-12 giugno 2026. I contenuti degli annunci sono educated guess basati su brevetti, beta sviluppatori e signals. Distinguete sempre fact da speculation.

### Tabella anticipazioni
| Evento | Data | Annunci attesi (label) |
|--------|------|-----------------------|
| Google I/O 2026 | **19-20 maggio 2026**, Shoreline Amphitheatre + io.google | MCP per AICore consumer (rumor); Play for On-Device AI in GA (probabile); Gemma 4 update minori (probabile) |
| Apple WWDC 2026 | **8-12 giugno 2026** | Core AI framework unificato (rumor forte); Siri Gemini-powered (rumor multi-fonte); Siri Extensions con Tool protocol pubblico (probabile); context window espansa oltre 4096 (probabile); API multimodale pubblica image+audio (probabile) |

### Visual
- **Descrizione**: Timeline orizzontale maggio-giugno 2026 con due milestone (logo Google I/O e logo Apple WWDC). Sotto ogni milestone, 3-4 bullet con icona "rumor/probabile/confermato".
- **Sorgente suggerita**: Layout timeline ad hoc.

### Speaker notes
Trasparenza massima qui: ogni bullet ha una label esplicita. "Confermato" sono date e organizzazione. "Probabile" sono cose con segnali multipli (beta API, brevetti, leak credibili). "Rumor" sono cose che potrebbero rivelarsi false. La sorpresa piu' grande potenziale e' l'integrazione Siri-Gemini: piu' fonti la danno per fatta, sarebbe il primo accordo cross-ecosystem AI di questa portata. Per Google I/O l'attesa principale e' MCP arrivare su consumer Android - oggi MCP e' developer tooling, ma se Google lo apre ai consumer prima di Apple, potrebbe diventare lo standard de facto. Per voi studenti il messaggio operativo e': ascoltate i keynote in diretta (sono gratis), e nei due giorni successivi leggete il technical deep dive nei session video - li' c'e' la sostanza. Aggiornero' il repo SOTA_2026.md entro fine giugno con i changes effettivi. Confrontate con questa slide e vedete dove ho azzeccato e dove ho sbagliato - utile per calibrare la mia credibilita' come fonte.

### Riferimenti
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md (sezione 12)
- https://blog.google/innovation-and-ai/technology/developers-tools/io-2026-save-the-date/
- https://io.google/2026/about
- https://blog.modelcontextprotocol.io/posts/2026-mcp-roadmap/

---

## Slide 56 — Take-away: i tre punti finali
**Timing**: min 94-96
**Tipo**: text

### Headline
Tre cose da portarsi a casa
### Sottotitolo
Dopo 95 minuti, se ricordate solo questo, ho fatto il mio lavoro

### Body
Sintesi finale. Tre messaggi che voglio rimangano anche tra sei mesi quando dimenticherete dettagli e numeri.

### Tre take-away
1. **L'on-device non e' piu' un esperimento**. Apple Foundation Models e Google Gemma 4 / ML Kit GenAI sono API stabili, GA, con SDK ufficiali e tooling Xcode/Android Studio. Non state scommettendo su tecnologia beta: state usando piattaforme di produzione.
2. **La quantizzazione e' il vero abilitatore**. Senza quantizzazione 4-bit standard e BitNet 1.58 nessun modello da 2-4 miliardi di parametri girerebbe sul telefono. Studiatela: e' la disciplina con il rapporto impatto/visibilita' migliore nel campo.
3. **Il prossimo salto e' l'agente mobile**. Tool calling nativo (Tool protocol Apple, FunctionGemma 270M) + memoria episodica + MCP = personal AI offline. E' l'area dove ci sono le lacune piu' grandi e quindi le opportunita' di carriera/research piu' chiare.

### Visual
- **Descrizione**: Tre card grandi numerate, ognuna con headline corta (3-5 parole) e icona (checkmark, gear, robot). Sotto, una linea: "Vedete nelle prossime slide come approfondire".
- **Sorgente suggerita**: Layout ad hoc, alta enfasi visiva.

### Speaker notes
Slide ad alta densita' emotiva, da pronunciare lentamente. Il primo punto e' un cambio di stato mentale: smettetela di pensare a on-device come "esperimento di Apple/Google" e iniziate a pensarci come piattaforma di produzione. Le aziende serie stanno gia' building sopra. Il secondo punto e' un consiglio di carriera: in un mondo in cui tutti vogliono lavorare su prompt engineering o LLM application layer, la quantizzazione e' un'area meno affollata, piu' fondamentale, e con domanda crescente perche' ogni nuovo modello richiede ottimizzazione mobile. Investite tempo li'. Il terzo punto e' la mia previsione strategica: nei prossimi 18 mesi l'agente mobile offline con tool nativi sara' il differenziatore competitivo per le app premium. Chi capisce ReAct + memoria + MCP oggi sara' in posizione di vantaggio. Ultima nota: queste tre frasi sono volutamente opinionate, non scientifiche. Sono il mio punto di vista basato su due anni di lavoro nel campo. Sfidatelo.

### Riferimenti
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SEMINAR.md (sezione 8)

---

## Slide 57 — Risorse: repo, docs, paper
**Timing**: min 96-98
**Tipo**: text

### Headline
Tutto in un posto: github.com/giadaf-boosha/ai_foundation_model_mobile
### Sottotitolo
Repo open source con codice, SOTA, riferimenti e roadmap

### Body
Ho impacchettato tutto cio' che ho mostrato in un repository pubblico. Codice Swift e Kotlin pronti, SOTA aggiornato ad aprile 2026, lista bibliografica completa, esercizi.

### Risorse principali
| Risorsa | Path / URL |
|---------|-----------|
| Repository GitHub | https://github.com/giadaf-boosha/ai_foundation_model_mobile |
| Outline seminario | SEMINAR.md |
| Stato dell'arte aprile 2026 | SOTA_2026.md (12 sezioni) |
| Bibliografia ragionata | RESOURCES.md |
| Comparazioni iOS vs Android | comparisons.md |
| Esempi codice | examples/ios/, examples/android/ |
| Deep dives tecnici | deep_dives/ |

### Paper chiave (top 5)
1. *Apple Intelligence Foundation Language Models 2025* — arXiv 2507.13575
2. *BitNet b1.58 2B4T: Native 1-bit LLMs at Scale* — arXiv 2504.12285
3. *NanoQuant: Sub-1-Bit Post-Training Quantization* — arXiv 2602.06694
4. *SpinQuant: LLM quantization with learned rotations* — arXiv 2405.16406
5. *Fast On-device LLM Inference with NPUs* — ASPLOS 2025

### Visual
- **Descrizione**: Slide dominata da un QR code grande al centro che punta a https://github.com/giadaf-boosha/ai_foundation_model_mobile. A lato, lista compatta dei file principali. In basso, 5 thumbnail dei paper chiave con link arXiv.
- **Sorgente suggerita**: Generare QR code con qrcode.com o libreria qrcode Python; mockup layout in Figma/Keynote.

### Speaker notes
Slide pratica. Inquadrate il QR ora con la fotocamera del telefono - aprira' il repo GitHub, e da li' avete accesso a tutto: i 6 esempi di codice della demo, il documento SOTA_2026.md che e' la mia ricognizione bibliografica completa, RESOURCES.md con i link tematizzati per area (Apple, Google, quantizzazione, agenti, MCP). I cinque paper in fondo sono il mio "se devi leggere solo cinque cose, leggi queste". L'ordine non e' casuale: Apple Tech Report e BitNet sono i due imprescindibili. NanoQuant e' la frontiera della quantizzazione estrema. SpinQuant e' la base teorica delle rotazioni apprese che molti runtime stanno adottando. ASPLOS25 e' il paper che vi spiega perche' NPU vs CPU non e' solo questione di velocita' ma di energia e quindi di batteria. Repository e' MIT licensed, sentitevi liberi di forkare, modificare, contribuire. Ho aperto le issues per suggerimenti.

### Riferimenti
- https://github.com/giadaf-boosha/ai_foundation_model_mobile
- /Users/giadafranceschini/code/ai_foundation_model_mobile/RESOURCES.md
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SOTA_2026.md

---

## Slide 58 — Domande di stimolo per la discussione
**Timing**: min 98-100
**Tipo**: text

### Headline
Quattro domande aperte per partire la discussione
### Sottotitolo
Non hanno risposte giuste — ho le mie ma voglio sentire le vostre

### Body
Prima di Q&A vere e proprie, vi propongo quattro spunti. Pensate due minuti, poi raccolgo le risposte piu' interessanti.

### Quattro domande
1. **Quale use case del vostro corso o progetto trarrebbe il massimo vantaggio dall'on-device?** Pensate a tesi, progetti d'esame, side project: qualcuno tra voi ha qualcosa che oggi gira in cloud ma sarebbe meglio offline?
2. **Come progettereste un'app che funziona "entrambi": on-device per default, cloud opzionale per qualita'?** Quali criteri di routing? UX cue per l'utente? Caching delle risposte cloud per uso offline successivo?
3. **Quale evoluzione dell'hardware mobile sbloccherebbe il prossimo livello?** RAM (16 GB+ standard)? NPU TOPS (>200)? Memory bandwidth? Storage I/O? Cosa e' il vero collo di bottiglia oggi?
4. **MCP arrivera' su mobile consumer? Su quale ecosistema prima — Android o iOS?** Quali incentivi commerciali? Quali rischi di sicurezza?

### Visual
- **Descrizione**: Quattro tile grandi numerate, ognuna con la domanda in evidenza e un'icona simbolica (use case lightbulb, hybrid arrow, hardware chip, MCP plug). Layout 2x2.
- **Sorgente suggerita**: Layout ad hoc.

### Speaker notes
Discussione, non monologo. Pongo le quattro domande, faccio una pausa di due minuti per riflessione individuale, poi giro la sala con il microfono. La domanda 1 e' personale: voglio capire se quanto detto risuona con i loro progetti reali. La 2 e' progettuale e tecnica: testa la capacita' di pensare ad architetture ibride - molto richiesta sul mercato. La 3 e' speculativa ma fondata: serve per capire chi ha intuizione di system thinking - la risposta corretta secondo me oggi e' memory bandwidth, non TOPS. La 4 e' la piu' aperta: la mia opinione personale e' che MCP arrivera' prima su Android perche' Google ha meno da perdere e piu' bisogno di differenziarsi, ma e' interpretabile in entrambi i sensi. Se nessuno parla per primo, chiamo io qualcuno - meglio breaking the ice che silenzio imbarazzato. Se uno solo parla a lungo, lo interrompo gentilmente per dare spazio ad altri. Tempo target: 5-7 minuti su 10 di Q&A totali.

### Riferimenti
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SEMINAR.md (sezione 9)

---

## Slide 59 — Q&A, grazie e contatti
**Timing**: min 100-103 (+buffer Q&A fino a min 120)
**Tipo**: text

### Headline
Grazie. Ora tocca a voi.
### Sottotitolo
Domande, critiche, idee di collaborazione — tutto benvenuto

### Body
Se non c'e' tempo per tutto in aula, scrivetemi. Email e LinkedIn sotto. Repo aperto a issue e PR.

### Contatti
- **Email**: giada.f@me.com
- **LinkedIn**: https://www.linkedin.com/in/giadafr/
- **GitHub**: https://github.com/giadaf-boosha
- **Repo seminario**: https://github.com/giadaf-boosha/ai_foundation_model_mobile

### Per gli studenti UniBO
- Disponibile per supervisioni informali su tesi/progetti su foundation models on-device.
- Contattatemi via email del prof. Montori per intermediazione formale.
- Se costruite qualcosa basato su questo materiale, mandatemelo: lo segnalero' nel repo.

### Visual
- **Descrizione**: Slide minimal: "Grazie." in font grande al centro, contatti sotto in formato compatto, QR code piccolo del repo in basso a destra. Logo UniBO e logo Boosha in fondo.
- **Sorgente suggerita**: Design ad hoc, stile pulito senza distrazioni.

### Speaker notes
Slide finale. Mantengo a video durante tutto il Q&A residuo (10-15 minuti circa). Apertura: "Grazie del tempo e dell'attenzione. Ho cercato di darvi un panorama tecnico onesto, con i limiti e le opportunita'. Ora sono a disposizione per qualsiasi domanda - tecnica, strategica, di carriera, anche scettica". Lascio sul tavolo i biglietti da visita se ne ho. Per il follow-up: l'email me la leggono in giornata, LinkedIn risponde entro 48 ore, GitHub issue entro una settimana. Per studenti UniBO interessati a tesi: passo via prof. Montori per filtrare e per rispetto istituzionale. Se qualcuno costruisce qualcosa di interessante basato sui materiali, lo segnalo volentieri nel README del repo - meccanismo di reciprocita' che funziona bene. Chiudo con: "Se vi sembra che io abbia detto qualcosa di sbagliato, ditemelo apertamente - il materiale e' open source e la versione 1.1 includera' i vostri feedback". Termine seminario.

### Riferimenti
- https://github.com/giadaf-boosha/ai_foundation_model_mobile
- /Users/giadafranceschini/code/ai_foundation_model_mobile/SEMINAR.md
