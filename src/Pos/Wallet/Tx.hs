-- | Functions for creating transactions

module Pos.Wallet.Tx
       ( makePubKeyTx
       ) where

import           Universum

import           Pos.Crypto (PublicKey, SecretKey)
import           Pos.Types  (Address, Coin, Redeemer (..), Tx (..), TxId, TxIn (..),
                             TxOut (..), Validator (..))

type TxInputs = [(TxId, Word32)]
type TxOutputs = [(Address, Coin)]

-- | Makes a transaction which use P2PKH addresses as a source
makePubKeyTx :: PublicKey -> SecretKey -> TxInputs -> TxOutputs -> Tx
makePubKeyTx pk sk inputs outputs = Tx {..}
  where txOutputs = map makeTxOut outputs
        txInputs = map makeTxIn inputs
        makeTxOut (txOutAddress, txOutValue) = TxOut {..}
        makeTxIn (txInHash, txInIndex) =
            TxIn { txInValidator = PubKeyValidator pk
                 , txInRedeemer = PubKeyRedeemer $ sign sk (txInHash, txInIndex, txOutputs)
                 }

