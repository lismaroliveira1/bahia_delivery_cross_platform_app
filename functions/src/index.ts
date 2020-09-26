import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin'
import { CieloConstructor, Cielo, TransactionCreditCardRequestModel, CaptureRequestModel, CancelTransactionRequestModel, EnumBrands } from 'cielo';
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
const merchantId = functions.config().cielo.merchantid;
const merchantkey = functions.config().cielo.merchantkey;
const cieloParams: CieloConstructor = {
    merchantId: merchantId,
    merchantKey: merchantkey,
    sandbox: true,
    debug: true,
}

const cielo = new Cielo(cieloParams);
export const helloWorld = functions.https.onCall((data, context) => {
    return { 
        data: "Hello from cloud functions!!!!"
    };
});

export const getUserData = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        return {
            "data": "Nenhum Usuário logado"
        };
    } 
    const snapshot = await admin.firestore().collection("users").doc(context.auth.uid).get();
    return {
        "data": snapshot.data()
    };
});

