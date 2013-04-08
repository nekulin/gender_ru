require 'spec_helper'

describe GenderRu::FullName do
  it { should respond_to(:name) }
  it { should respond_to(:patronymic) }
  it { should respond_to(:surname) }
  it { should respond_to(:gender) }
  it { should respond_to(:ethnicity) }

  describe 'constructor' do
    it 'should accept hash as first param' do
      expect{ described_class.new {} }.to_not raise_error
    end

    it 'should set name, surname, patronymic, gender and ethnicity' do
      subj = described_class.new surname: 'Прокофьева', name: 'Глафира', patronymic: 'Ильинична'
      subj.name.should == 'Глафира'
      subj.surname.should == 'Прокофьева'
      subj.patronymic.should == 'Ильинична'
      subj.gender.should == :female
      subj.ethnicity.should == :russian
    end

    it 'should detect azerbaijanians by patronymic' do
      %w(Орхан-оглы Орхан-кызы Орхан-улы Джамал-гызы).each do |patr|
        subj = described_class.new surname: 'Джеваншир', name: 'Джамал', patronymic: patr
        subj.should be_azerbaijanian
      end
    end

    it 'should detect russians by patronymic' do
      %w(Михайлович Михайловна Ильинична).each do |patr|
        subj = described_class.new surname: 'Джеваншир', name: 'Джамал', patronymic: patr
        subj.should be_russian
      end
    end

    it 'should detect gender by patronymic' do
      %w(Петровна Ильинична Орхан-кызы Джамал-гызы).each do |patr|
        subj = described_class.new surname: 'Джеваншир', name: 'Джамал', patronymic: patr
        subj.should be_female
      end

      %w(Петрович Орхан-оглы Орхан-улы).each do |patr|
        subj = described_class.new surname: 'Джеваншир', name: 'Джамал', patronymic: patr
        subj.should be_male
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

  describe '#russian?' do
    it 'should return true when ethnicity is :russian' do
      subject.instance_eval { @ethnicity = :russian }
      subject.should be_russian
    end

    it 'should return false when ethnicity is not :russian' do
      ['russian', 0, nil, {}, []].each do |value|
        subject.instance_eval { @ethnicity = value }
        subject.should_not be_russian
      end
    end
  end

  describe '#azerbaijanian?' do
    it 'should return true when ethnicity is :azerbaijanian' do
      subject.instance_eval { @ethnicity = :azerbaijanian }
      subject.should be_azerbaijanian
    end

    it 'should return false when ethnicity is not :azerbaijanian' do
      ['azerbaijanian', 0, nil, {}, []].each do |value|
        subject.instance_eval { @ethnicity = value }
        subject.should_not be_azerbaijanian
      end
    end
  end
end