// Used for global injection in test run
const path = require('path');

// Matrix of Schema to resolve locally while testing
const schemas = [
  'address',
  'amount',
  'barcode',
  'cartItem',
  'cashier',
  'communication',
  'country',
  'currency',
  'gps',
  'gtin8',
  'gtin13',
  'identifier',
  'image',
  'location',
  'loyalty',
  'merchant',
  'name',
  'payment',
  'phoneNumber',
  'pos',
  'posData',
  'price',
  'product',
  'quantifier',
  'receipt',
  'serviceTime',
  'street',
  'tax',
  'terminal',
  'truncatedNumber',
  'uuid',
];

// Schemas with Sub-Schemas
const subSchemas = {
  'loyalty': ['loyaltyBuffered', 'loyaltyStructured'],
  'name': ['legalName', 'peopleName'],
  'payment': ['cashlessPayment', 'cashPayment'],
  'pos': ['pos', 'posInside', 'posOutside', 'posVirtual'],
  'product': ['eanProduct', 'genericProduct'],
  'tax': ['tax', 'taxIdEu', 'taxOverview'],
  'terminal': ['terminalBuffered', 'terminalStructured'],
};

// Status of initialization TRUE = init done
let initDone = false;

// URL for schemas
const schemaBaseURL = 'https://bitbucket.org/wunderbon/json-schemas/raw/master/schema/';

// Extension
const schemaExtension = '.schema.json';

// Load a schema file
function resolveSchema(node, file) {
  return require(path.join(__dirname, '..', 'schema', node, file));
}

// Load a data file
function resolveData(node, file) {
  return require(path.join(__dirname, '..', 'data', node, file));
}

// Export
module.exports = {
  activeSchema: undefined,
  dataValid: undefined,
  dataInvalid: undefined,
  initFixtures: function (chai, target) {
    if (!initDone) {
      module.exports.activeSchema = resolveSchema(target, target + schemaExtension);
      module.exports.dataValid    = resolveData(target, target + '.json');
      module.exports.dataInvalid  = resolveData(target, target + '.invalid.json');

      // Build $ref $id matrix
      for (let schema in schemas) {
        if (subSchemas[schemas[schema]]) {
          for (let subSchema in subSchemas[schemas[schema]]) {
            chai.ajv.addSchema(require(path.join(__dirname, '..', 'schema', schemas[schema], subSchemas[schemas[schema]][subSchema] + schemaExtension)), schemaBaseURL + schemas[schema] + '/' + subSchemas[schemas[schema]][subSchema] + schemaExtension);
          }
        } else {
          chai.ajv.addSchema(require(path.join(__dirname, '..', 'schema', schemas[schema], schemas[schema] + schemaExtension)), schemaBaseURL + schemas[schema] + '/' + schemas[schema] + schemaExtension);
        }
      }

      initDone = true;
    }
  },
};
