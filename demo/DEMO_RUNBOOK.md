# Demo Runbook — Pre / Durante / Failure

## T-24h (giorno prima)

```bash
cd demo
make doctor       # tutto OK
make doctor-pull  # modelli scaricati
make build-apple  # binari compilati (cache pronta)
make demo-1       # smoke test Apple
make demo-4       # smoke test Google
```

Tutto deve girare end-to-end senza errori. Se qualcosa fallisce, hai 24h per risolvere.

## T-1h (in aula)

1. **Carica batteria al 100%**, collega alimentatore (Apple Intelligence consuma).
2. **Disabilita notifiche**: `Focus → Do Not Disturb`.
3. **Risoluzione terminale**: imposta a 1920x1080 minimo, font ~22pt.
4. **Profilo iTerm/Terminal "Seminar"**: sfondo nero, font Menlo/JetBrains Mono 22pt, colori ANSI default.
5. **Connetti al proiettore**, verifica leggibilità ultima fila.
6. **Test airplane mode**: attiva, lancia `make demo-1`, deve funzionare comunque (Apple FM è on-device). Riattiva rete dopo.
7. **Pre-warm modello Apple**: `cd apple && swift run BasicChat "ciao"` — la prima esecuzione carica il modello (~5s), le successive sono istantanee.
8. **Pre-warm modello Gemma**: `ollama run gemma3:4b "ciao"` — idem.

## Durante il talk (slide 43)

Dopo la slide 43 ("Apriamo il terminale"), Cmd+Tab al terminale a tutto schermo.

```bash
make seminar
```

Premi invio quando vuoi avanzare. Le 5 demo girano in sequenza con narrativa testuale tra una e l'altra.

## Failure mode — cosa fare se qualcosa rompe

### Apple FM non disponibile
**Sintomo**: `✗ Modello non disponibile: ...`
**Mitigazione**:
- Verifica Apple Intelligence attivo: `Settings → Apple Intelligence & Siri → On`
- Se ancora ko, salta direttamente a `make demo-4` (Google) e torna a recuperare Apple in coda
- Backup ultimo: torna alle slide 47 (backup statiche Apple) e mostra il codice come slide

### ollama non risponde
**Sintomo**: `make demo-4` blocca o errore
**Mitigazione**:
```bash
killall ollama
ollama serve &
sleep 2
ollama list  # verifica
```

### Build Swift fallisce in aula
**Sintomo**: errori compilazione Swift durante demo Apple
**Mitigazione**: è proprio per questo che `make build-apple` va lanciato a T-1h. Se non l'hai fatto e ora rompe, salta Apple e fai solo Google. Spiega "il build è cached, normalmente parte istantaneo".

### Network freeze / proiettore disconnesso
**Mitigazione**: continua. Tutte le demo sono on-device, niente dipende dalla rete.

### Ti perdi il punto
**Mitigazione**: `Ctrl+C` per uscire da qualsiasi demo, `make demo-N` per riavviarne una specifica, `make seminar` per riavviare tutto.

## Comandi utili durante Q&A

```bash
# Replay di una singola demo
make demo-3

# Cambia prompt al volo
cd apple && swift run BasicChat "domanda dal pubblico"
bash google/basic-chat.sh "domanda dal pubblico"

# Forza modello Gemma diverso
GEMMA_MODEL=gemma4:31b make demo-4   # se hai pullato il 31B

# Reset visuale
clear; make doctor
```

## Output atteso (per confronto in aula)

### Demo 1 (Apple BasicChat)
- Tempo: 2-5s totali
- Output: 3 frasi in italiano sull'on-device AI
- Latenza visualizzata in fondo

### Demo 2 (Apple Streaming)
- Time-to-first-token: ~300-500ms
- Output cresce visibilmente token per token
- Latenza totale ~3-8s a seconda lunghezza

### Demo 3 (Apple Tool Calling)
- Modello chiama getWeather(city: "Bologna") + calculate(expression: "144 / 12")
- Output: risposta naturale che integra "18°C soleggiato" e "12"
- Nessun routing scritto da noi

### Demo 4 (Google Gemma)
- Tempo: 5-15s a seconda hardware
- Output: 3 frasi in italiano (Gemma è multilingua)

### Demo 5 (Google Function Calling)
- Output JSON: `{"tool": "getWeather", "arguments": {"city": "Bologna"}}`
- Dispatch: `✓ Tool dispatch: getWeather`
- Risultato simulato

## Regola d'oro

**Mai improvvisare durante il talk.** Se una demo non parte al primo tentativo, non insistere: passa alla successiva, recupera in coda. La cosa peggiore è 5 minuti di silenzio davanti al pubblico mentre risolvi. Tutto è progettato per essere skippable.
