
require "rails_helper"

describe Course::Compiler do
  let(:course) {
    Course.create(:name => "nodejs")
  }

  let(:compiler) {
    course.compiler
  }

  describe "#list_of_pages" do
    it "list directories that has an index document" do
      expect(compiler.list_of_pages.sort).to eql(
        ["api-driven-development",
          "build-the-express-app",
          "build-the-middleware-stack",
           "class-inheritance",
           "class-system",
           "conditional-get",
           "content-negotiation",
           "create-npm-package",
           "dependence-injection",
           "extending-request-response",
           "mini-harp-preprocessor",
           "mini-harp-server",
           "path-matcher",
           "path-matcher-fancy",
           "router-chaining",
           "router-http-verbs",
           "send-file",
           "setting-up-mocha",
           "using-coffeescript",
           "why-middleware"])
    end
  end

  describe "#pages_xml" do
    it("compiles all pages into a list of <page> tags") do
      xml = compiler.pages_xml
      expect(xml).to be_a(String)
      puts xml
    end
  end

  describe "#weeks_xml" do
    it("includes references to all lessons, organized in <week> tags") do
      xml = compiler.weeks_xml
      expect(xml).to be_a(String)
      puts xml
    end
  end

  describe "#course_xml" do
    it("compiles the course into a single xml") do
      xml = compiler.course_xml
      puts xml
    end
  end
end