module.exports = function(config) {
  config.set({
    files: [
      "app/**/*.js",
      "test/**/*.js",
      "!*/di-configuration*.js",
      "!app/**/*interface.js",
    ],
    testRunner: "mocha",
    mutator: "javascript",
    mutate: ["app/**/*.js", "!app/di-configuration.js", "!app/**/*interface.js"],
    transpilers: [],
  reporters: ["html", "progress"],
  testFramework: "mocha",
  coverageAnalysis: "perTest",
  htmlReporter: {
  baseDir: "docs/report/mutation/html"
}
});
};
