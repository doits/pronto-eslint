require 'spec_helper'

module Pronto
  describe ESLintNpm do
    let(:eslint) { ESLintNpm.new(patches) }
    let(:patches) { [] }

    describe '#run' do
      subject(:run) { eslint.run }

      context 'patches are nil' do
        let(:patches) { nil }

        it 'returns an empty array' do
          expect(run).to eql([])
        end
      end

      context 'no patches' do
        let(:patches) { [] }

        it 'returns an empty array' do
          expect(run).to eql([])
        end
      end

      context 'patches with a one and a four warnings' do
        include_context 'test repo'

        let(:patches) { repo.diff('master') }

        it 'returns correct number of errors' do
          expect(run.count).to eql(5)
        end

        it 'has correct first message' do
          expect(run.first.msg).to eql("'foo' is not defined.")
        end

        context(
          'with files to lint config that never matches',
          config: { 'files_to_lint' => 'will never match' }
        ) do
          it 'returns zero errors' do
            expect(run.count).to eql(0)
          end
        end

        context(
          'with files to lint config that matches only .js',
          config: { 'files_to_lint' => '\.js$' }
        ) do
          it 'returns correct amount of errors' do
            expect(run.count).to eql(2)
          end
        end

        context(
          'with cmd_line_opts to include .html',
          config: { 'cmd_line_opts' => '--ext .html' }
        ) do
          it 'returns correct number of errors' do
            expect(run.count).to eql 5
          end
        end

        context(
          'with different eslint executable',
          config: { 'eslint_executable' => './custom_eslint.sh' }
        ) do
          it 'calls the custom eslint eslint_executable' do
            expect { run }.to raise_error(JSON::ParserError, /custom eslint called/)
          end
        end
      end

      context 'repo with ignored and not ignored file, each with three warnings' do
        include_context 'eslintignore repo'

        let(:patches) { repo.diff('master') }

        it 'returns correct number of errors' do
          expect(run.count).to eql(3)
        end

        it 'has correct first message' do
          expect(run.first.msg).to eql("'HelloWorld' is defined but never used.")
        end
      end
    end

    describe '#files_to_lint' do
      subject(:files_to_lint) { eslint.files_to_lint }

      it 'matches .js by default' do
        expect(files_to_lint).to match('my_js.js')
      end

      it 'matches .es6 by default' do
        expect(files_to_lint).to match('my_js.es6')
      end
    end

    describe '#eslint_executable' do
      subject(:eslint_executable) { eslint.eslint_executable }

      it 'is `eslint` by default' do
        expect(eslint_executable).to eql('eslint')
      end
    end
  end
end
