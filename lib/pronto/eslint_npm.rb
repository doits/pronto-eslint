require 'pronto'
require 'shellwords'

module Pronto
  class ESLintNpm < Runner
    def run
      return [] unless @patches

      @patches.select { |patch| patch.additions > 0 }
        .select { |patch| js_file?(patch.new_file_full_path) }
        .map { |patch| inspect(patch) }
        .flatten.compact
    end

    def inspect(patch)
      @_repo_path ||= @patches.first.repo.path

      offences = run_eslint(patch)
      clean_up_eslint_output(offences)
        .map do |offence|
          patch
            .added_lines
            .select { |line| line.new_lineno == offence['line'] }
            .map { |line| new_message(offence, line) }
        end
    end

    private

    def new_message(offence, line)
      path = line.patch.delta.new_file[:path]
      level = :warning

      Message.new(path, line, level, offence['message'], nil, self.class)
    end

    def js_file?(path)
      path.to_s =~ /(\.js|\.es6|\.js\.es6)(\.erb)?$/
    end

    def run_eslint(patch)
      Dir.chdir(@_repo_path) do
        JSON.parse(
          `eslint #{Shellwords.escape(patch.new_file_full_path.to_s)} -f json`
        )
      end
    end

    # rubocop:disable Metrics/LineLength
    def clean_up_eslint_output(output)
      # 1. Filter out offences without a warning or error
      # 2. Get the messages for that file
      # 3. Ignore errors without a line number for now
      output
        .select { |offence| offence['errorCount'] + offence['warningCount'] > 0 }
        .map { |offence| offence['messages'] }
        .flatten.select { |offence| offence['line'] }
    end
  end
end
