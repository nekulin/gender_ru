require 'spec_helper'

describe GenderRu::FullName do

  let(:expected_locale_data) do
    {
      'ru' => {
        'ethnicity' => {
          'unknown' => 'Не известно',
          'russian'  => 'Русский',
          'azerbaijanian' => 'Азербайджанец'
        },
        'gender' => {
          'unknown' => 'Не известно',
          'male' => 'Мужской',
          'female' => 'Женский'
        }
      },
      'en' => {
        'ethnicity' => {
          'unknown' => 'Unknown',
          'russian' => 'Russian',
          'azerbaijanian' => 'Azerbaijanian'
        },
        'gender' => {
          'unknown' => 'Unknown',
          'male' => 'Male',
          'female' => 'Female'
        }
      }
    }
  end

  it { should respond_to(:name) }
  it { should respond_to(:patronymic) }
  it { should respond_to(:surname) }
  it { should respond_to(:gender) }
  it { should respond_to(:ethnicity) }

  describe 'constructor' do
    it 'should accept hash as first param' do
      expect{ described_class.new {} }.to_not raise_error
    end

    it 'should set gender and ethnicity to unknown by default' do
      subject.ethnicity.should == :unknown
      subject.gender.should == :unknown
    end

    it 'should set name, surname, patronymic, gender and ethnicity' do
      subj = described_class.new surname: 'Прокофьева', name: 'Глафира', patronymic: 'Ильинична'
      subj.name.should == 'Глафира'
      subj.surname.should == 'Прокофьева'
      subj.patronymic.should == 'Ильинична'
      subj.gender.should == :female
      subj.ethnicity.should == :russian
    end

    it 'should set name, surname, patronymic, gender and ethnicity even if hash contains string keys' do
      subj = described_class.new 'surname' => 'Прокофьева', 'name' => 'Глафира', 'patronymic' => 'Ильинична'
      subj.name.should == 'Глафира'
      subj.surname.should == 'Прокофьева'
      subj.patronymic.should == 'Ильинична'
      subj.gender.should == :female
      subj.ethnicity.should == :russian
    end

    it 'should not use :gender or :ethnicity from hash' do
      [{:gender => :male, :ethnicity => :russian},
       {'gender' => :male, 'ethnicity' => :russian}].each do |options|
        subj = described_class.new options
        subj.gender.should == :unknown
        subj.ethnicity.should == :unknown
      end
    end
  end

  describe '#male_surname' do
    def male_surname_test(surname, expected)
      subj = described_class.new surname: surname, name: 'Анна', patronymic: 'Ильинична'
      subj.male_surname.should == expected
    end

    it 'should return an empty string when an empty string given' do
      subj = described_class.new {}
      subj.male_surname.should == ''
    end

    it 'should return surname when male?' do
      subj = described_class.new surname: 'Цукерберг', name: 'Марк', patronymic: 'Васильевич'
      subj.male_surname.should == 'Цукерберг'
    end

    it 'should not change original surname' do
      subj = described_class.new surname: 'Цветаева', name: 'Анна', patronymic: 'Ильинична'
      ->{ subj.male_surname }.should_not change(subj, :surname)
    end

    it "should return 'Поздний' when 'Поздняя' given" do
      male_surname_test 'Поздняя', 'Поздний'
    end

    it "should return 'Рокосовский' when 'Рокосовская' given" do
      male_surname_test 'Рокосовская', 'Рокосовский'
    end

    it "should return 'Ушедший' when 'Ушедшая' given" do
      male_surname_test 'Ушедшая', 'Ушедший'
    end

    it "should return 'Кормчий' when 'Кормчая' given" do
      male_surname_test 'Кормчая', 'Кормчий'
    end

    it "should return 'Корноухий' when 'Корноухая' given" do
      male_surname_test 'Корноухая', 'Корноухий'
    end

    it "should return 'Куций' when 'Куцая' given" do
      male_surname_test 'Куцая', 'Куций'
    end

    it "should return 'Щадящий' when 'Щадящяя' given" do
      male_surname_test 'Щадящяя', 'Щадящий'
    end

    it "should return 'Фая' when 'Фая' given" do
      male_surname_test 'Фая', 'Фая'
    end

    it "should return 'Кошевой' when 'Кошевая' given" do
      male_surname_test 'Кошевая', 'Кошевой'
    end

    it "should return 'Пушной' when 'Пушная' given" do
      male_surname_test 'Пушная', 'Пушной'
    end

    it "should return 'Толстой' when 'Толстая' given" do
      male_surname_test 'Толстая', 'Толстой'
    end

    it "should return 'Трибой' when 'Трибая' given" do
      male_surname_test 'Трибая', 'Трибой'
    end

    it "should return 'Ямковой' when 'Ямковая' given" do
      male_surname_test 'Ямковая', 'Ямковой'
    end

    it "should return 'Ушаков' when 'Ушакова' given" do
      male_surname_test 'Ушакова', 'Ушаков'
    end

    it "should return 'Лунёв' when 'Лунёва' given" do
      male_surname_test 'Лунёва', 'Лунёв'
    end

    it "should return 'Плигин' when 'Плигина' given" do
      male_surname_test 'Плигина', 'Плигин'
    end

    it "should return 'Каменев' when 'Каменева' given" do
      male_surname_test 'Каменева', 'Каменев'
    end

    it "should return 'Голубь' when 'Голубь' given" do
      male_surname_test 'Голубь', 'Голубь'
    end

    it "should return 'Язва' when 'Язва' given" do
      male_surname_test 'Язва', 'Язва'
    end

    it "should return 'Стена' when 'Стена' given" do
      male_surname_test 'Стена', 'Стена'
    end

    it "should return 'Дорофиенко' when 'Дорофиенко' given" do
      male_surname_test 'Дорофиенко', 'Дорофиенко'
    end

    it "should return 'Штрилиц' when 'Штирлиц' given" do
      male_surname_test 'Штирлиц', 'Штирлиц'
    end

    it "should return 'Болконский-Яузов' when 'Болконская-Яузова' given" do
      male_surname_test 'Болконская-Яузова', 'Болконский-Яузов'
    end

    it "should return 'Болконский-Яузов' when 'Болконская-Яузова' given" do
      male_surname_test 'Гран-Приева', 'Гран-Приев'
    end

    it 'should change russain surname for azerbaijanian woman' do
      subj = described_class.new surname: 'Гулиева', name: 'Анна', patronymic: 'Джамал-кызы'
      subj.male_surname.should == 'Гулиев'
    end

    it 'should not change azerbaijanian surname for azerbaijanian woman' do
      subj = described_class.new surname: 'Дильбази', name: 'Анна', patronymic: 'Джамал-кызы'
      subj.male_surname.should == 'Дильбази'
    end
  end

  describe '#male?' do
    it 'should return true when gender is :male' do
      subject.instance_eval { @gender = :male }
      subject.should be_male
    end

    it 'should return false when gender is not :male' do
      ['male', 0, nil, {}, [], :female].each do |value|
        subject.instance_eval { @gender = value }
        subject.should_not be_male
      end
    end
  end

  describe '#female?' do
    it 'should return true when gender is :female' do
      subject.instance_eval { @gender = :female }
      subject.should be_female
    end

    it 'should return false when gender is not :female' do
      ['female', 0, nil, {}, [], :male].each do |value|
        subject.instance_eval { @gender = value }
        subject.should_not be_female
      end
    end
  end

  describe '#humanize' do
    it 'should use english locale by default' do
      subject = described_class.new name: 'Иван', patronymic: 'Иванович', surname: 'Иванов'
      subject.humanize(:ethnicity).should == 'Russian'
    end

    it 'should return method\'s stringified value if locale is missing' do
      subject.humanize(:male?).should == subject.male?.to_s
    end

    it 'should return proper values' do


      test_cases = {
        ethnicity: [:unknown, :russian, :azerbaijanian],
        gender: [:unknown, :male, :female]
      }

      [:en, :ru].each do |locale|
        test_cases.each do |method, stubs|
          stubs.each do |value|
            subject.stub(method).and_return(value)
            subject.humanize(method, locale).should == expected_locale_data[locale.to_s][method.to_s][value.to_s]
          end
        end
      end
    end

    it 'should use .locale_data' do
      described_class.should_receive(:locale_data).and_return({})
      subject.humanize(:ethnicity).should == 'unknown'
    end
  end

  describe '.ethnicity' do
    it 'should delegatge to just created object' do
      options = { name: 'Иван', patronymic: 'Иванович', surname: 'Иванов'}
      obj = stub
      obj.should_receive(:ethnicity).and_return('something special')
      described_class.should_receive(:new).with(options).and_return(obj)
      described_class.ethnicity(options).should == 'something special'
    end
  end

  describe '.gender' do
    it 'should delegatge to just created object' do
      options = { name: 'Иван', patronymic: 'Иванович', surname: 'Иванов'}
      obj = stub
      obj.should_receive(:gender).and_return('something special')
      described_class.should_receive(:new).with(options).and_return(obj)
      described_class.gender(options).should == 'something special'
    end
  end
end
