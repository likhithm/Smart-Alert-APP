const functions = require("firebase-functions")
const BigQuery = require("@google-cloud/bigquery")

function toDate(dateStr) {
 if (dateStr !== null){
 const [day, month, year] = dateStr.split("-")
 return new Date(year, month - 1, day)
 }
 else {
 return null
 }
}

exports.animalsToBQ = functions.firestore
.document("/animals/{animalID}")
.onWrite((change, context) => {
//console.log(`new create event for document ID: ${event.data.id}`)


let config = functions.config()

datasetName = config.bigquery.datasetname
tableName = config.bigquery.animalstablename
let bigquery = new BigQuery()

let dataset = bigquery.dataset(datasetName)
dataset.exists().catch(err => {
    console.error(
    `dataset.exists: dataset ${datasetName} does not exist: ${JSON.stringify(
    err
)}`
)
return err
})

let table = dataset.table(tableName)
table.exists().catch(err => {
console.error(
    `table.exists: table ${tableName} does not exist: ${JSON.stringify(
    err
)}`
)
return err
})

const document = change.after.exists ? change.after.data() : null;

//const timestamp = bigquery.timestamp(new Date());
let row = {
insertId: document.id,
json: {
    animalID: context.params.animalID,
    birthDate: toDate(document.birthDate),
    animalBreed: document.animalBreed,
    encodedImage: document.encodedImage,
    gender: document.gender,
    animalName: document.animalName,
    purchaseDate: toDate(document.purchaseDate),
    animalType: document.animalType,
    userID: document.userID,
    logDate: new Date(),
},
}

return table.insert(row, { raw: true }).catch(err => {
console.error(`table.insert: ${JSON.stringify(err)}`)
return err
})
})

//events//
exports.eventsToBQ = functions.firestore
.document("/events/{eventID}")
.onWrite((change, context) => {
//console.log(`new create event for document ID: ${event.data.id}`)


let config = functions.config()

datasetName = config.bigquery.datasetname
tableName = config.bigquery.eventstablename
let bigquery = new BigQuery()

let dataset = bigquery.dataset(datasetName)
dataset.exists().catch(err => {
    console.error(
    `dataset.exists: dataset ${datasetName} does not exist: ${JSON.stringify(
    err
)}`
)
return err
})

let table = dataset.table(tableName)
table.exists().catch(err => {
console.error(
`table.exists: table ${tableName} does not exist: ${JSON.stringify(
err
)}`
)
return err
})

const document = change.after.exists ? change.after.data() : null;

let row = {
    insertId: document.id,
    json: {
    eventID: context.params.eventID,
    animalID: document.animalID,
    eventDate: toDate(document.eventDate),
    eventType: document.eventType,
    eventDescription: document.eventDescription,
    userID: document.userID,
    logDate: new Date(),
},
}

return table.insert(row, { raw: true }).catch(err => {
console.error(`table.insert: ${JSON.stringify(err)}`)
return err
})
})

//yields//
exports.yieldsToBQ = functions.firestore
.document("/yields/{yieldID}")
.onWrite((change, context) => {
//console.log(`new create event for document ID: ${event.data.id}`)


let config = functions.config()

datasetName = config.bigquery.datasetname
tableName = config.bigquery.yieldstablename
let bigquery = new BigQuery()

let dataset = bigquery.dataset(datasetName)
dataset.exists().catch(err => {
    console.error(
    `dataset.exists: dataset ${datasetName} does not exist: ${JSON.stringify(
    err
)}`
)
return err
})

let table = dataset.table(tableName)
table.exists().catch(err => {
console.error(
`table.exists: table ${tableName} does not exist: ${JSON.stringify(
err
)}`
)
return err
})

const document = change.after.exists ? change.after.data() : null;

//const timestamp = bigquery.timestamp(new Date());
let row = {
insertId: document.id,
json: {
    yieldID: context.params.yieldID,
    animalID: document.animalID,
    yieldDate: toDate(document.yieldDate),
    yieldTime: document.yieldTime,
    yieldQty: document.yieldQty,
    logDate: new Date(),
},
}

return table.insert(row, { raw: true }).catch(err => {
console.error(`table.insert: ${JSON.stringify(err)}`)
return err
})
})

//users//
exports.usersToBQ = functions.firestore
.document("/users/{userID}")
.onWrite((change, context) => {
//console.log(`new create event for document ID: ${event.data.id}`)


let config = functions.config()

datasetName = config.bigquery.datasetname
tableName = config.bigquery.usersstablename
let bigquery = new BigQuery()

let dataset = bigquery.dataset(datasetName)
dataset.exists().catch(err => {
    console.error(
    `dataset.exists: dataset ${datasetName} does not exist: ${JSON.stringify(
    err
)}`
)
return err
})

let table = dataset.table(tableName)
table.exists().catch(err => {
console.error(
`table.exists: table ${tableName} does not exist: ${JSON.stringify(
err
)}`
)
return err
})

const document = change.after.exists ? change.after.data() : null;

let row = {
insertId: document.id,
json: {
    userID: context.params.userID,
    aadhaarNumber: document.aadhaarNumber,
    encodedImage: document.encodedImage,
    location: document.location,
    authUID: document.authUID,
    userName: document.userName,
    userPhone: document.userPhone,
    logDate: new Date(),
},
}

return table.insert(row, { raw: true }).catch(err => {
console.error(`table.insert: ${JSON.stringify(err)}`)
return err
})
})
