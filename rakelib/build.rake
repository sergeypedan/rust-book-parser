desc "Builds epub"

task "build" do
  require_relative "../lib/processor"
  # Processor.create_pages!
  Processor.create_opf!
  Processor.create_epub!
end
