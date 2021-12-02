RSpec.describe OTR::ActiveRecord do
  describe '.configure_from_file!' do
    context 'when simple configuration file is given' do
      let(:config) { Bundler.root.join('spec/fixtures/simple.yml') }

      it 'configures active record' do
        described_class.configure_from_file!(config)
        t = ::ActiveRecord::Base.configurations['test'].with_indifferent_access
        expect(t[:adapter]).to eq 'sqlite3'
        expect(t[:database]).to eq 'tmp/simple.sqlite3'
        expect(t[:migrations_paths]).to eq ['db/migrate']
      end
    end

    context 'when configuration file with multiple roles given' do
      let(:config) { Bundler.root.join('spec/fixtures/multi.yml') }

      it 'configures active record' do
        described_class.configure_from_file!(config)
        t = ::ActiveRecord::Base.configurations['test'].with_indifferent_access
        expect(t[:adapter]).to eq 'sqlite3'
        expect(t[:database]).to eq 'tmp/multi.sqlite3'
        expect(t[:migrations_paths]).to eq ['db/migrate']
      end
    end
  end
end
