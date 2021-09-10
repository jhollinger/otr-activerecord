RSpec.describe OTR::ActiveRecord do
  describe '.configure_from_file!' do
    context 'when simple configuration file is given' do
      let(:config) { Bundler.root.join('spec/fixtures/simple.yml') }

      it 'configures active record' do
        described_class.configure_from_file!(config)

        expect(::ActiveRecord::Base.configurations['test']).to eq(
          adapter: 'sqlite3',
          database: 'tmp/simple.sqlite3',
          migrations_paths: ['db/migrate']
        )
      end
    end

    context 'when configuration file with multiple roles given' do
      let(:config) { Bundler.root.join('spec/fixtures/multi.yml') }

      it 'configures active record' do
        described_class.configure_from_file!(config)

        expect(::ActiveRecord::Base.configurations['test']).to eq(
          adapter: 'sqlite3',
          database: 'tmp/multi.sqlite3',
          migrations_paths: ['db/migrate']
        )
      end
    end
  end
end
