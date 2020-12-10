import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin'
import { CieloConstructor, Cielo, TransactionCreditCardRequestModel, EnumBrands } from 'cielo';

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript

admin.initializeApp(functions.config().firebase);
const merchantId = functions.config().cielo.merchantid;
const merchantkey = functions.config().cielo.merchantkey;
const cieloParams: CieloConstructor = {
    merchantId: merchantId,
    merchantKey: merchantkey,
    sandbox: true,
    debug: true
};

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
    console.log("ok");
    console.log(data.creditCard.brand);
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
                    "message": "Cartão não suportado: " + data.creditCard.brand
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
        console.log("ok");
        const transaction = await cielo.creditCard.transaction(saleData);
        console.log(transaction.payment.authorizeNow);
        if (transaction.payment.status === 1) {
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
                    "message": message
                }
            };
        }
    } catch (e) {
        return {
            "success": false,
            "error": {
                'code': e.response[0],
                'message': e.response[0]
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

export const onNewOrder = functions.firestore.document("/orders/{orderId}").onCreate(async (data, context) => {
    const orderId = context.params.orderId;
    console.log(orderId);
    const orderSnapshot = await admin.firestore()
        .collection("orders").doc(orderId).get();
    const orderData = orderSnapshot.data() || {};
    const storeSnapshot = await admin.firestore()
        .collection("stores").doc(orderData.storeId).get();
    const storeData = storeSnapshot.data() || {};
    const querySnapshot = await admin.firestore().collection("users").doc(storeData.partnerId).collection("tokens").get();
    console.log("aqui");
    const tokens = querySnapshot.docs.map(doc => doc.id);
    await sendPushFCM(tokens, 'Novo Pedido', 'Nova venda realizada. Pedido: ' + orderId);
    console.log(tokens);
});

async function sendPushFCM(tokens: string[], title: string, message: string) {
    if (tokens.length > 0) {
        const payload = {
            notification: {
                title: title,
                body: message,
                click_action: 'FLUTTER_NOTIFICATION_CLICK'

            }
        };
        return admin.messaging().sendToDevice(tokens, payload);
    } return;
}

const orderStatus = new Map([
    [1, "Aguardando reposta da Loja"],
    [2, "Tudo ok! Seu pedido já está em preparação."],
    [3, "Opa! Seu pedido saiu para entrega"],
    [4, "Parabéns!!! O pedido foi entregue"],
    [5, "Por algum motivo, seu pedido foi cancelado pela loja"]
]);
export const onOrderStatusChanged = functions
    .firestore.document("/orders/{orderId}").onUpdate(async (snapshot, contexxt) => {
        const beforeStatus = snapshot.before.data().status;
        const afterStatus = snapshot.after.data().status;
        if (beforeStatus !== afterStatus) {
            const tokensUser = await admin.firestore().collection("users")
                .doc(snapshot.after.data().client).collection("tokens").get();
            const tokens = tokensUser.docs.map(doc => doc.id);
            await sendPushFCM(tokens,
                'Novo status do pedido',
                '' + orderStatus.get(afterStatus));
        }

    });

const partnerStatus = new Map([
    [1, "Parabéns!! Seja bem vindo! Agora você é um Parceiro Bahia Delivery!!"],
    [2, "Agora é so esperar, sua proposta está em análise"],
    [3, "Você está na modalidade somente usuário"],
    [4, "Sua conta Parceiro Bahia Delivey está temporariamente suspensa."]

]);
export const onParnerterStatusChanged = functions.firestore.document("/users/{isPartner}").onUpdate(async (snapshot, context) => {
    const beforeStatus = snapshot.before.data().isPartner;
    const afterStatus = snapshot.after.data().isPartner;
    console.log(beforeStatus);
    if (beforeStatus !== afterStatus) {
        console.log("entrou na função");
        const storeDataUser = await admin.firestore().collection("stores")
            .doc(snapshot.after.data().storeId).get();
        const newDataUser = storeDataUser.data() || {};
        console.log(newDataUser.partnerId);
        const tokensPartnerUser = await admin.firestore().collection("users").
            doc(newDataUser.partnerId).collection("tokens").get();
        const partnerTokens = tokensPartnerUser.docs.map(doc => doc.id);
        await sendPushFCM(partnerTokens, 'Nova Atualização',
            '' + partnerStatus.get(afterStatus));
    }
});

export const onOrderChatUpdated = functions.firestore.document("/orders/{orderId}/chat/{chatId}").onCreate(async (data, context) => {
    const orderId = context.params.orderId;
    const chatId = context.params.chatId;
    console.log(orderId);
    console.log(chatId);
    const orderChatSnapshot = await admin.firestore().collection("orders")
        .doc(orderId).get();
    const orderChatData = orderChatSnapshot.data() || {};
    const chatSnapshot = await admin.firestore().collection("orders")
        .doc(orderId).collection("chat").doc(chatId).get();
    const chatData = chatSnapshot.data() || {};
    if (chatData.userId === orderChatData.client) {
        const chatStoreSnapshot = await admin.firestore()
            .collection("stores").doc(orderChatData.storeId).get();
        const chatStoreData = chatStoreSnapshot.data() || {};
        const tokensChatUserStore = await admin.firestore().collection("users").
            doc(chatStoreData.partnerId).collection("tokens").get();
        const partnerChatStoreTokens = tokensChatUserStore.docs.map(doc => doc.id);
        await sendPushFCM(partnerChatStoreTokens, 'Nova mensagem de ' + orderChatData.clientName,
            '' + chatData.text);

    }
    if (chatData.userId === orderChatData.storeId) {
        const tokensChatUser = await admin.firestore().collection("users").
            doc(orderChatData.client).collection("tokens").get();
        const partnerChatUserTokens = tokensChatUser.docs.map(doc => doc.id);
        await sendPushFCM(partnerChatUserTokens, 'Nova mensagem de ' + orderChatData.StoreName,
            '' + chatData.text);

    }
});