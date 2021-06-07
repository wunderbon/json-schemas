
// Imports
const chai  = require('chai');
const tools = require('../../helper');
const path  = require('path');

chai.use(require('chai-json-schema-ajv'))

// Assertion styles @todo Choose one!
const expect = chai.expect

// Tell chai that we'll be using the "should" style assertions.
chai.expect();

// Detect target for test
let scriptName = path.basename(__filename);
const testTarget = scriptName.split('.')[0];

// Generic bootstrapping
tools.initFixtures(chai, testTarget);

// Test suite definition
describe('Testing schema "' + testTarget + '"', function () {

  // Test definition
  it('Validating schema', function(done) {
    expect(tools.activeSchema, tools.dataValid).to.be.validJsonSchema
    expect(tools.activeSchema, tools.dataInvalid).to.be.validJsonSchema

    done();
  });

  // Test definition
  it('Validating data', function(done) {
    expect(tools.dataValid).to.be.jsonSchema(tools.activeSchema);
    expect(tools.dataInvalid).to.not.be.jsonSchema(tools.activeSchema)

    done();
  });
});
