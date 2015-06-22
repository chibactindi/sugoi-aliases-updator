require 'spec_helper'

describe SugoiAliasesUpdator::LineParser do
  let(:comment_line) { "# #{line}" }

  subject { SugoiAliasesUpdator::LineParser.new(line) }

  context '区切り文字がタブの時' do
    let(:line) { 'root:		 admin@exmaple.com, hoge@exmaple.com, postfix@exmaple.com' }
    it 'be valid margin' do
      expect(subject.margin).to eq '		 '
    end
    it 'be valid is_aliaes_line' do
      expect(subject.is_aliaes_line).to eq true
    end
    it 'be valid emails' do
      expect(
        subject.emails_line
      ).to eq 'admin@exmaple.com, hoge@exmaple.com, postfix@exmaple.com'
    end
    it 'be valid label' do
      expect(
        subject.label
      ).to eq 'root'
    end
  end

  context '区切り文字がスペースの時' do
    it 'be valid margin' do
      expect(subject.margin).to eq '  '
    end
    let(:line) { 'root:  admin@exmaple.com, hoge@exmaple.com, postfix@exmaple.com' }
    it 'be valid is_aliaes_line' do
      expect(subject.is_aliaes_line).to eq true
    end
    it 'be valid emails' do
      expect(
        subject.emails_line
      ).to eq 'admin@exmaple.com, hoge@exmaple.com, postfix@exmaple.com'
    end
    it 'be valid label' do
      expect(
        subject.label
      ).to eq 'root'
    end
  end
end