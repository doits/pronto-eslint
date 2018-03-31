# frozen_string_literal: true

require 'fileutils'
require 'byebug'
require 'rspec'
require 'pronto/eslint_npm'

%w[test eslintignore].each do |repo_name|
  RSpec.shared_context "#{repo_name} repo" do
    let(:git) { "spec/fixtures/#{repo_name}.git/git" }
    let(:dot_git) { "spec/fixtures/#{repo_name}.git/.git" }

    before { FileUtils.mv(git, dot_git) }
    let(:repo) { Pronto::Git::Repository.new("spec/fixtures/#{repo_name}.git") }
    after { FileUtils.mv(dot_git, git) }
  end
end

RSpec.shared_context 'with config', config: true do
  requested_config = metadata[:config]

  before(:each) do
    allow_any_instance_of(Pronto::ESLintNpm).to receive(:config_options).and_return(requested_config)
  end
end
