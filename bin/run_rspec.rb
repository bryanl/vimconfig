spec_dir=File.dirname(ARGV[0])
rails_project_dir="#{spec_dir}/../.."

report_file="#{rails_project_dir}/doc/rspec_report.html"

rspec_rails_plugin = File.join(rails_project_dir,'vendor','plugins','rspec','lib')
if File.directory?(rspec_rails_plugin)
  $LOAD_PATH.unshift(rspec_rails_plugin)
else
  require 'rubygems'
  require 'spec'
end
require 'rubygems'
require 'spec'
require 'spec/runner/formatter/html_formatter'

module Spec
  module Runner
    module Formatter
      class HtmlFormatter
        def backtrace_line(line)
          line.gsub(/([^:]*\.rb):(\d*)/) do
            "<a href=\"gedit://#{File.expand_path($1)}?#{$2}\">#{$1}:#{$2}</a> "
          end
        end
      end
    end
  end
end

if File.exists? report_file
  File.delete report_file
end

argv = [ARGV[0]]
argv << "--c"
argv << "--format"
argv << "html:#{report_file}"

::Spec::Runner::CommandLine.run(::Spec::Runner::OptionParser.parse(argv, STDERR, STDOUT))

if File.exists? report_file
  `firefox #{report_file}`
end
