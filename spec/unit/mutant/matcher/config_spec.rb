# frozen_string_literal: true

RSpec.describe Mutant::Matcher::Config do
  describe '#merge' do
    def apply
      original.merge(other)
    end

    let(:proc_a) { instance_double(Proc, :a) }
    let(:proc_b) { instance_double(Proc, :b) }

    let(:original) do
      described_class.new(
        ignore:            [parse_expression('Ignore#a')],
        start_expressions: [parse_expression('Start#a')],
        subject_filters:   [proc_a],
        subjects:          [parse_expression('Match#a')]
      )
    end

    let(:other) do
      described_class.new(
        ignore:            [parse_expression('Ignore#b')],
        start_expressions: [parse_expression('Start#b')],
        subject_filters:   [proc_b],
        subjects:          [parse_expression('Match#b')]
      )
    end

    it 'merges all config keys' do
      expect(apply).to eql(
        described_class.new(
          ignore:            [parse_expression('Ignore#a'), parse_expression('Ignore#b')],
          start_expressions: [parse_expression('Start#a'), parse_expression('Start#b')],
          subject_filters:   [proc_a, proc_b],
          subjects:          [parse_expression('Match#a'), parse_expression('Match#b')]
        )
      )
    end
  end

  describe '#inspect' do
    subject { object.inspect }

    context 'on default config' do
      let(:object) { described_class::DEFAULT }

      it { should eql('#<Mutant::Matcher::Config empty>') }
    end

    context 'with one expression' do
      let(:object) { described_class::DEFAULT.add(:subjects, parse_expression('Foo')) }
      it { should eql('#<Mutant::Matcher::Config subjects: [Foo]>') }
    end

    context 'with many expressions' do
      let(:object) do
        described_class::DEFAULT
          .add(:subjects, parse_expression('Foo'))
          .add(:subjects, parse_expression('Bar'))
      end

      it { should eql('#<Mutant::Matcher::Config subjects: [Foo,Bar]>') }
    end

    context 'with match and ignore expression' do
      let(:object) do
        described_class::DEFAULT
          .add(:subjects, parse_expression('Foo'))
          .add(:ignore,   parse_expression('Bar'))
      end

      it { should eql('#<Mutant::Matcher::Config ignore: [Bar] subjects: [Foo]>') }
    end

    context 'with subject filter' do
      let(:object) do
        described_class::DEFAULT
          .add(:subject_filters, 'foo')
      end

      it { should eql('#<Mutant::Matcher::Config subject_filters: ["foo"]>') }
    end
  end
end
