import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin'
import { CieloConstructor, Cielo, TransactionCreditCardRequestModel, EnumBrands } from 'cielo';

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

export const authorizedCreditCard = functions.https.onCall(async (data, context) => {
    if (data === null) {
        return {
            "success": false,
            "error": {
                "code": -1,
                "message": "Dados não informados"
            }
        };
    }
    if (!context.auth) {
        return {
            "success": false,
            "error": {
                "code": -1,
                "message": "Nenhum Usuário Logado"
            }
        };
    }

    const userId = context.auth.uid;
    const snapshot = await admin.firestore().collection("users").doc(userId).get();
    const userData = snapshot.data() || {};
    console.log('Inciando autorização');
    let brand: EnumBrands;
    switch (data.creditCard.brand) {
        case "visa":
            brand = EnumBrands.VISA;
            break;
        case "mastercard":
            brand = EnumBrands.MASTER;
            break;
        case "dinersclub":
            brand = EnumBrands.DINERS;
            break;
        case "americamexpress":
            brand = EnumBrands.AMEX
            break;
        case "discover":
            brand = EnumBrands.DISCOVER;
            break;
        case "jcb":
            brand = EnumBrands.JCB;
            break;
        case "maestro":
            brand = EnumBrands.MASTER;
            break;
        case "hipercard":
            brand = EnumBrands.HIPERCARD;
            break;
        case "elo":
            brand = EnumBrands.ELO;
            break;
        case "aura":
            brand = EnumBrands.AURA;
            break;
        case "discovery":
            brand = EnumBrands.DISCOVERY;
            break;
        default:
            return {
                "success": false,
                "error": {
                    "code": -1,
                    "message": "Caratão não suportado: " + data.creditCard.brand
                }
            };
    }
    const saleData: TransactionCreditCardRequestModel = {
        merchantOrderId: data.merchantOrderId,
        customer: {
            name: userData.name,
            identity: data.cpf,
            identityType: "CPF",
            email: userData.email,
            deliveryAddress: {
                street: userData.address.street,
                number: userData.address.state,
                complement: userData.address.complement,
                zipCode: userData.address.zipCode,
                city: userData.address.city,
                state: userData.address.state,
                country: "BRA",
                district: userData.address.district
            }
        },
        payment: {
            currency: "BRL",
            country: "BRA",
            amount: data.amount,
            installments: data.installments,
            softDescriptor: data.softDescriptor,
            type: data.paymentType,
            capture: false,
            creditCard: {
                cardNumber: data.creditCard.cardNumber,
                holder: data.creditCard.holder,
                expirationDate: data.creditCard.expirationDate,
                brand: brand
            }
        }
    }
    
    try {
        const transaction = await cielo.creditCard.transaction(saleData);
        if (transaction.payment.status == 1) {
            return {
                "success": true,
                "paymentId": transaction.payment.paymentId
            };
        } else {
            let message = '';
            switch (transaction.payment.returnCode) {
                case '5':
                    message = 'Não Autorizada';
                    break;
                case '57':
                    message = "Cartão Expirado";
                    break;
                case '78':
                    message = "Cartão Bloqueado";
                    break;
                case '99':
                    message = 'Time Out';
                    break;
                case '77':
                    message = 'Cartão Cancelado';
                    break;
                default:
                    message = transaction.payment.returnMessage;
                    break;
            }
            return {
                "success": false,
                "status": transaction.payment.status,
                "error": {
                    "code": transaction.payment.returnCode,
                    "message": message,
                }
            };
        }
    } catch (e) {
        return {
            "success": false,
            "error": {
                'code': e.response[0].Code,
                'message': e.response[0].Message,
            }
        };
    }

});

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

