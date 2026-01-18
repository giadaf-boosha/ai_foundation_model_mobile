# Architetture Agentiche per LLM Mobile: Guida Completa

> Approfondimento tecnico sui pattern architetturali per costruire [agenti AI](https://en.wikipedia.org/wiki/Intelligent_agent) autonomi su dispositivi mobili.

![Agentic AI](https://miro.medium.com/v2/resize:fit:1400/1*JKBKvS8i7qVQS9l9SuBNZw.png)
*Architettura base di un agente AI con loop percezione-azione*

---

## Indice

1. [Cosa sono gli agenti AI](#cosa-sono-gli-agenti-ai)
2. [Pattern ReAct](#pattern-react)
3. [Planning agents](#planning-agents)
4. [Multi-agent systems](#multi-agent-systems)
5. [Gestione della memoria](#gestione-della-memoria)
6. [Edge General Intelligence](#edge-general-intelligence)
7. [Implementazione su mobile](#implementazione-su-mobile)
8. [Best practices](#best-practices)

---

## Cosa sono gli agenti AI

Un **agente AI** è un sistema autonomo che può:
1. **Percepire** l'ambiente attraverso input
2. **Ragionare** sullo stato e gli obiettivi
3. **Agire** eseguendo azioni concrete
4. **Apprendere** dalle osservazioni

### Differenza tra LLM e Agent

| Caratteristica | LLM Standard | LLM Agent |
|----------------|--------------|-----------|
| Modalità | Singola risposta | Loop continuo |
| Interazione | Solo testo | Tool, API, ambiente |
| Stato | Stateless | Mantiene stato/memoria |
| Autonomia | Passivo | Autonomo |

### Il loop agentico

```
        ┌─────────────────────────────────────┐
        │                                     │
        ▼                                     │
   ┌─────────┐    ┌─────────┐    ┌──────────┐│
   │ Perceive│───▶│  Think  │───▶│   Act    ││
   └─────────┘    └─────────┘    └──────────┘│
        ▲                             │       │
        │         ┌─────────┐         │       │
        └─────────│ Observe │◀────────┘       │
                  └─────────┘                 │
                        │                     │
                        └─────────────────────┘
```

---

## Pattern ReAct

### Definizione

**ReAct (Reasoning + Acting)** è un framework introdotto da [Yao et al. (2023)](https://arxiv.org/abs/2210.03629) che combina:
- **Reasoning**: catene di pensiero esplicite (Chain-of-Thought)
- **Acting**: azioni concrete con tool esterni

### Struttura del prompt ReAct

```
Thought: [Ragionamento sul problema]
Action: [Nome dell'azione da eseguire]
Action Input: [Input per l'azione]
Observation: [Risultato dell'azione]
... (ripeti)
Thought: [Ho abbastanza informazioni]
Final Answer: [Risposta finale]
```

### Vantaggi rispetto a Chain-of-Thought

| Aspetto | CoT | ReAct |
|---------|-----|-------|
| Tipo | Solo mentale | Mentale + azioni |
| Aggiornamento | No | Si, basato su osservazioni |
| Hallucination | Più probabile | Ridotte (feedback reale) |
| Flessibilità | Limitata | Alta (tool esterni) |

### Limitazioni

1. **Overhead computazionale**: prompt più lunghi
2. **Latenza**: ogni ciclo richiede inference
3. **Modelli piccoli**: performance peggiore senza fine-tuning
4. **Complessità**: orchestrazione più complessa

### Sviluppi recenti (2025-2026)

- **RP-ReAct**: separa planning strategico da esecuzione low-level
- **UAV-CodeAgents**: gerarchie di agenti per robotica
- **Hybrid agents**: combinazione ReAct + reinforcement learning

---

## Planning agents

### Cos'è un planning agent

Un **planning agent** scompone obiettivi complessi in sotto-task eseguibili, creando un piano d'azione prima dell'esecuzione.

### Architettura tipica

```
┌──────────────────────────────────────────────┐
│                PLANNING AGENT                 │
├──────────────────────────────────────────────┤
│  ┌────────────┐    ┌────────────┐            │
│  │   Goal     │───▶│  Planner   │            │
│  │  Analysis  │    │   (LLM)    │            │
│  └────────────┘    └─────┬──────┘            │
│                          │                    │
│                    ┌─────▼──────┐            │
│                    │   Plan     │            │
│                    │   Store    │            │
│                    └─────┬──────┘            │
│                          │                    │
│  ┌────────────┐    ┌─────▼──────┐            │
│  │  Monitor   │◀───│  Executor  │            │
│  │ & Replan   │    │            │            │
│  └────────────┘    └────────────┘            │
└──────────────────────────────────────────────┘
```

### Strategie di planning

#### 1. Task decomposition
Scompone un task complesso in sotto-task più semplici:

```
Goal: "Organizza un viaggio a Roma"
  ├── Task 1: Cerca voli disponibili
  ├── Task 2: Trova hotel nel budget
  ├── Task 3: Identifica attrazioni
  └── Task 4: Crea itinerario giornaliero
```

#### 2. Hierarchical planning
Piani a più livelli di astrazione:

```
Livello strategico: Obiettivo generale
    │
    ▼
Livello tattico: Sotto-obiettivi
    │
    ▼
Livello operativo: Azioni concrete
```

#### 3. Adaptive replanning
Modifica il piano basandosi sui feedback:

```
Plan → Execute → Observe → [Success?]
                              │
                    No ◀──────┴───────▶ Yes
                    │                    │
              ┌─────▼─────┐        ┌─────▼─────┐
              │  Replan   │        │  Continue │
              └───────────┘        └───────────┘
```

---

## Multi-agent systems

### Architettura multi-agente

Invece di un singolo agente monolitico, sistemi di **agenti specializzati** che collaborano.

### Pattern principali

#### 1. Orchestrator pattern
Un agente centrale coordina agenti specializzati:

```
              ┌──────────────┐
              │ Orchestrator │
              └──────┬───────┘
         ┌──────────┼──────────┐
         ▼          ▼          ▼
    ┌────────┐ ┌────────┐ ┌────────┐
    │Research│ │ Writer │ │Reviewer│
    │ Agent  │ │ Agent  │ │ Agent  │
    └────────┘ └────────┘ └────────┘
```

#### 2. Peer-to-peer pattern
Agenti che comunicano direttamente:

```
    ┌────────┐     ┌────────┐
    │Agent A │◀───▶│Agent B │
    └────┬───┘     └───┬────┘
         │             │
         └──────┬──────┘
                ▼
          ┌────────┐
          │Agent C │
          └────────┘
```

#### 3. Hierarchical pattern
Struttura gerarchica con agenti supervisor:

```
              ┌──────────────┐
              │ Global Agent │
              └──────┬───────┘
         ┌──────────┴──────────┐
         ▼                     ▼
    ┌─────────┐           ┌─────────┐
    │Sub-Agent│           │Sub-Agent│
    │   Edge  │           │Terminal │
    └────┬────┘           └────┬────┘
    ┌────┴────┐           ┌────┴────┐
    │ Worker  │           │ Worker  │
    │ Agents  │           │ Agents  │
    └─────────┘           └─────────┘
```

### Vantaggi multi-agent

| Vantaggio | Descrizione |
|-----------|-------------|
| **Specializzazione** | Ogni agente eccelle in un dominio |
| **Fault tolerance** | Fallimento isolato |
| **Scalabilità** | Aggiungi agenti per nuove funzioni |
| **Parallelismo** | Task indipendenti in parallelo |

### Sfide

- **Comunicazione overhead**: latenza tra agenti
- **Sincronizzazione**: coordinamento complesso
- **Risorse**: multipli LLM = più memoria
- **Sicurezza**: superficie d'attacco più ampia

### Trend di mercato (2025-2026)

Secondo [Gartner](https://www.gartner.com/en/articles/intelligent-agent-in-ai):
- **+1,445%** di richieste su multi-agent systems (Q1 2024 → Q2 2025)
- **40%** delle applicazioni enterprise avranno AI agents entro fine 2026
- Mercato: $7.8B (2025) → $52B (2030)

---

## Gestione della memoria

### Il problema della context window

| Modello | Context window | Limitazione |
|---------|----------------|-------------|
| GPT-4o | 128K tokens | - |
| Claude 3.5 | 200K tokens | - |
| Gemini 2.5 Pro | 1M tokens | - |
| **On-device** | 2-4K tokens | **Critica** |

Su mobile, la context window è drasticamente ridotta, rendendo la gestione della memoria fondamentale.

### MemGPT: memoria gerarchica

[MemGPT](https://arxiv.org/abs/2310.08560) implementa una gerarchia di memoria simile ai sistemi operativi:

> Repository: [cpacker/MemGPT](https://github.com/cpacker/MemGPT)

```
┌─────────────────────────────────────────────┐
│              MEMORIA GERARCHICA              │
├─────────────────────────────────────────────┤
│                                              │
│  ┌──────────────────────────────────────┐   │
│  │         MAIN CONTEXT (RAM)           │   │
│  │    - Context window attiva           │   │
│  │    - Informazioni immediate          │   │
│  │    - 2-4K tokens                     │   │
│  └──────────────────────────────────────┘   │
│                     │                        │
│              ┌──────┴──────┐                │
│              │  Page In/Out│                │
│              └──────┬──────┘                │
│                     │                        │
│  ┌──────────────────▼───────────────────┐   │
│  │       EXTERNAL CONTEXT (Disk)         │   │
│  │    - Memoria a lungo termine          │   │
│  │    - Conversazioni passate            │   │
│  │    - Knowledge base                   │   │
│  │    - Illimitata                       │   │
│  └──────────────────────────────────────┘   │
│                                              │
└─────────────────────────────────────────────┘
```

### Tipi di memoria per agenti

#### 1. Working memory (breve termine)
- Context window corrente
- Stato del task attuale
- Informazioni temporanee

#### 2. Episodic memory (esperienze)
- Conversazioni passate
- Interazioni precedenti
- Errori e successi

#### 3. Semantic memory (conoscenza)
- Fatti e concetti
- Knowledge base
- Informazioni utente

#### 4. Procedural memory (come fare)
- Procedure apprese
- Tool usage patterns
- Strategie di successo

### Strategie di compressione

#### Summarization
```
Conversazione lunga → Riassunto conciso
[5000 tokens]        [500 tokens]
```

#### Hierarchical summarization
```
Sessione 1 → Summary 1 ─┐
Sessione 2 → Summary 2 ─┼─→ Meta-summary
Sessione 3 → Summary 3 ─┘
```

#### Selective retention
```
Importanza: Alta   → Mantieni verbatim
Importanza: Media  → Riassumi
Importanza: Bassa  → Scarta
```

### MemLoRA (2025)

Approccio specifico per mobile che usa **adapter LoRA** per codificare memoria a lungo termine:
- Distilla knowledge in adapter leggeri
- Riduce overhead computazionale
- Ottimizzato per deployment on-device

---

## Edge General Intelligence

### Cos'è EGI

**Edge General Intelligence (EGI)** è un paradigma che abilita nodi edge a eseguire cicli continui di percezione-ragionamento-azione con minima dipendenza dal cloud.

### Caratteristiche EGI

| Aspetto | Cloud AI | Edge AI | EGI |
|---------|----------|---------|-----|
| Latenza | Alta | Bassa | Ultra-bassa |
| Privacy | Rischio | Alta | Massima |
| Autonomia | Dipendente | Parziale | Completa |
| Adattabilità | Limitata | Moderata | Alta |

### Abilitatori tecnologici

1. **Agentic AI frameworks**: orchestrazione autonoma
2. **On-device compressed LLMs**: modelli quantizzati
3. **Federated architectures**: apprendimento distribuito
4. **Knowledge distillation**: trasferimento efficiente
5. **Decentralized decision**: autonomia locale

### Use case EGI

- **IoT**: sensori intelligenti autonomi
- **Vehicular networks**: veicoli autonomi
- **UAV swarms**: droni coordinati
- **Mobile assistants**: assistenti personali

### Architettura Multi-LLM per Edge

```
┌─────────────────────────────────────────────────────┐
│                    EDGE CLUSTER                      │
├─────────────────────────────────────────────────────┤
│                                                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐          │
│  │ Device 1 │  │ Device 2 │  │ Device 3 │          │
│  │  LLM-A   │──│  LLM-B   │──│  LLM-C   │          │
│  │ (Vision) │  │ (NLU)    │  │(Planning)│          │
│  └──────────┘  └──────────┘  └──────────┘          │
│        │             │             │                │
│        └─────────────┼─────────────┘                │
│                      │                              │
│              ┌───────▼───────┐                      │
│              │  Orchestrator │                      │
│              │    (Edge)     │                      │
│              └───────────────┘                      │
│                                                      │
└─────────────────────────────────────────────────────┘
```

### Framework 6G per Multi-Agent

Ricerca recente (2025) propone architetture dual-loop per reti 6G:

**Outer loop**: Collaborazione global agent ↔ sub-agents
**Inner loop**: Esecuzione locale su edge/terminal

---

## Implementazione su mobile

### Vincoli mobile

| Risorsa | Desktop | Mobile | Impatto |
|---------|---------|--------|---------|
| RAM | 16-64 GB | 4-12 GB | Modelli più piccoli |
| CPU/GPU | Potente | Limitato | Inference più lenta |
| Batteria | N/A | Critica | Efficienza energetica |
| Connettività | Stabile | Variabile | Offline capability |

### Strategie di adattamento

#### 1. Modelli appropriati
```
Desktop: Gemma 3 12B, Llama 3 70B
Mobile:  Gemma 3n 2B, Apple FM 3B
```

#### 2. Agenti leggeri
- Loop ReAct semplificato
- Meno step di reasoning
- Tool set ridotto

#### 3. Memoria efficiente
- Summarization aggressiva
- Context window piccola (2-4K)
- Offload su storage locale

#### 4. Ibrido cloud-edge
```
Task semplici → On-device
Task complessi → Cloud fallback
```

### Pattern consigliati per mobile

#### Single-agent ottimizzato
Per la maggior parte dei casi d'uso mobile:

```
┌─────────────────────────────────┐
│     MOBILE AGENT SEMPLICE       │
├─────────────────────────────────┤
│  ┌─────────┐    ┌─────────┐    │
│  │  Input  │───▶│  LLM    │    │
│  └─────────┘    │  (3B)   │    │
│                 └────┬────┘    │
│                      │         │
│  ┌─────────┐    ┌────▼────┐   │
│  │  Tools  │◀───│ Router  │   │
│  │ (Local) │    └─────────┘   │
│  └─────────┘                   │
└─────────────────────────────────┘
```

#### Hierarchical con cloud fallback
Per task complessi:

```
┌──────────────────────────────────────────┐
│              ON-DEVICE                    │
│  ┌─────────────────────────────────┐     │
│  │    Simple Agent (sempre on)     │     │
│  └─────────────┬───────────────────┘     │
│                │                          │
│         [Task complexity?]               │
│           │           │                   │
│        Low/Med      High                 │
│           │           │                   │
│    ┌──────▼──────┐   │                   │
│    │Process Local│   │                   │
│    └─────────────┘   │                   │
└──────────────────────┼───────────────────┘
                       │
                       ▼
               ┌───────────────┐
               │    CLOUD      │
               │ Complex Agent │
               └───────────────┘
```

---

## Best practices

### 1. Inizia semplice

```
MVP: Single agent + 2-3 tools
Poi: Aggiungi complessità se necessario
```

### 2. Limita i cicli ReAct

```
Max iterations: 3-5 su mobile
Timeout: 10-15 secondi totali
```

### 3. Tool set minimale

Seleziona solo i tool essenziali:
- Troppi tool = confusione + latenza
- 3-5 tool ben definiti sono sufficienti

### 4. Gestisci la memoria proattivamente

```swift
// iOS - Comprimi dopo ogni interazione
func afterInteraction() {
    if context.tokenCount > 2000 {
        context = summarize(context)
    }
}
```

### 5. Fallback graceful

```
if (onDeviceTimeout || lowBattery || complexity > threshold) {
    fallbackToCloud()
} else {
    processLocally()
}
```

### 6. Monitora le risorse

```kotlin
// Android - Check risorse prima di agire
fun shouldProcessLocally(): Boolean {
    val availableMemory = getAvailableMemory()
    val batteryLevel = getBatteryLevel()
    return availableMemory > 500.MB && batteryLevel > 20
}
```

### 7. User feedback loop

L'utente deve poter:
- Interrompere processi lunghi
- Vedere lo stato dell'agente
- Fornire correzioni

---

## Risorse aggiuntive

### Paper fondamentali
- [ReAct: Synergizing Reasoning and Acting](https://arxiv.org/abs/2210.03629)
- [MemGPT: Towards LLMs as Operating Systems](https://arxiv.org/abs/2310.08560)
- [Multi-LLM Edge Orchestration](https://arxiv.org/html/2507.00672v1)

### Repository
- [Autonomous Agents Papers](https://github.com/tmgthb/Autonomous-Agents)
- [Agent Memory Paper List](https://github.com/Shichun-Liu/Agent-Memory-Paper-List)
- [Awesome Memory for Agents](https://github.com/TsinghuaC3I/Awesome-Memory-for-Agents)

### Guide pratiche
- [Building ReAct Agents with Gemini](https://medium.com/google-cloud/building-react-agents-from-scratch-a-hands-on-guide-using-gemini-ffe4621d90ae)
- [ReAct Prompting Guide](https://www.promptingguide.ai/techniques/react)
- [Letta Memory Blocks](https://www.letta.com/blog/memory-blocks)

---

## Glossario

| Termine | Definizione |
|---------|-------------|
| **Agent** | Sistema AI autonomo che percepisce, ragiona e agisce |
| **ReAct** | Framework Reasoning + Acting |
| **CoT** | Chain-of-Thought, ragionamento step-by-step |
| **Tool** | Funzione esterna che l'agente può invocare |
| **Orchestrator** | Agente che coordina altri agenti |
| **EGI** | Edge General Intelligence |
| **Working memory** | Memoria a breve termine (context window) |
| **Episodic memory** | Memoria delle esperienze passate |
| **Semantic memory** | Memoria della conoscenza |

---

*Ultimo aggiornamento: Gennaio 2026*
