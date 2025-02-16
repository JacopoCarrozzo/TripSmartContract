# TripManager Smart Contract

## Descrizione  
TripManager è uno smart contract scritto in Solidity per gestire la prenotazione di viaggi senza intermediari. Il contratto permette ai clienti di prenotare viaggi, gestire i pagamenti in modo sicuro e garantire il trasferimento dei fondi ai fornitori di servizi turistici al completamento del viaggio.  

## Funzionalità  
- **Prenotazione di un viaggio**: I clienti possono prenotare un viaggio pagando l'importo richiesto.  
- **Completamento del viaggio**: I fornitori ricevono il pagamento una volta completato il viaggio.  
- **Annullamento della prenotazione**: I clienti possono annullare la prenotazione e ottenere un rimborso.  
- **Gestione dei saldi**: È possibile visualizzare il saldo dei clienti e dei fornitori.  
- **Prelievo dei fondi**: I fornitori possono prelevare i propri fondi guadagnati.  

## Struttura del Codice  
- **`TravelLibrary`**: Libreria per la gestione della struttura dei viaggi.  
- **`TripManager`**: Contratto principale che utilizza `TravelLibrary` per gestire le prenotazioni.  

## Installazione  
1. Assicurarsi di avere un ambiente di sviluppo Solidity (Remix, Hardhat, Foundry, o Truffle).  
2. Compilare e distribuire il contratto su una blockchain compatibile con Ethereum.  

## Licenza  
Questo progetto è distribuito sotto la licenza MIT.  
