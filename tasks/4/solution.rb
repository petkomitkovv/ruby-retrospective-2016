RSpec.describe 'Version' do
  describe '#initialize' do
    it 'does not raise error with empty string' do
      expect { Version.new '' }.to_not raise_error
    end

    it 'does not raise error with valid version' do
      expect { Version.new '1.2.3' }.to_not raise_error
    end

    it 'raises error with invalid version' do
      version = '1..2'
      expect { Version.new version }.to raise_error(
        ArgumentError,
        "Invalid version string '#{version}'"
      )
    end

    it 'does not raise error with no arguments' do
      expect { Version.new }.to_not raise_error
    end

    it 'does not raise error with version instance' do
      expect { Version.new Version.new }.to_not raise_error
    end
  end

  describe '#<' do
    context 'when versions have equal length' do
      it 'is true for smaller version' do
        expect(Version.new('1.2')).to be < Version.new('1.3')
      end

      it 'is false for larger version' do
        expect(Version.new('1.3')).to_not be < Version.new('1.2')
      end

      it 'is false for equal versions' do
        expect(Version.new('1.2')).to_not be < Version.new('1.2')
      end
    end

    context 'when versions have different length' do
      it 'is true for smaller version' do
        expect(Version.new('1.3')).to be < Version.new('1.3.1')
      end

      it 'is false for larger version' do
        expect(Version.new('1.3.1')).to_not be < Version.new('1.3')
      end

      it 'is false for equal versions' do
        expect(Version.new('1.3')).to_not be < Version.new('1.3.0')
      end
    end
  end

  describe '#>' do
    context 'when versions have equal length' do
      it 'is true for larger version' do
        expect(Version.new('1.3')).to be > Version.new('1.2')
      end

      it 'is false for smaller version' do
        expect(Version.new('1.2')).to_not be > Version.new('1.3')
      end

      it 'is false for equal versions' do
        expect(Version.new('1.2')).to_not be > Version.new('1.2')
      end
    end

    context 'when versions have different length' do
      it 'is true for larger version' do
        expect(Version.new('1.3.1')).to be > Version.new('1.3')
      end

      it 'is false for smaller version' do
        expect(Version.new('1.3')).to_not be > Version.new('1.3.1')
      end

      it 'is false for equal versions' do
        expect(Version.new('1.3')).to_not be > Version.new('1.3.0')
      end
    end
  end

  describe '#<=' do
    context 'when versions have equal length' do
      it 'is true for smaller version' do
        expect(Version.new('1.2')).to be <= Version.new('1.3')
      end

      it 'is false for larger version' do
        expect(Version.new('1.3')).to_not be <= Version.new('1.2')
      end

      it 'is true for equal versions' do
        expect(Version.new('1.2')).to be <= Version.new('1.2')
      end
    end

    context 'when versions have different length' do
      it 'is true for smaller version' do
        expect(Version.new('1.3')).to be <= Version.new('1.3.1')
      end

      it 'is false for larger version' do
        expect(Version.new('1.3.1')).to_not be <= Version.new('1.3')
      end

      it 'is true for equal versions' do
        expect(Version.new('1.3')).to be <= Version.new('1.3.0')
      end
    end
  end

  describe '#>=' do
    context 'when versions have equal length' do
      it 'is true for larger version' do
        expect(Version.new('1.3')).to be >= Version.new('1.2')
      end

      it 'is false for smaller version' do
        expect(Version.new('1.2')).to_not be >= Version.new('1.3')
      end

      it 'is true for equal versions' do
        expect(Version.new('1.2')).to be >= Version.new('1.2')
      end
    end

    context 'when versions have different length' do
      it 'is true for larger version' do
        expect(Version.new('1.3.1')).to be >= Version.new('1.3')
      end

      it 'is false for smaller version' do
        expect(Version.new('1.3')).to_not be >= Version.new('1.3.1')
      end

      it 'is true for equal versions' do
        expect(Version.new('1.3')).to be >= Version.new('1.3.0')
      end
    end
  end

  describe '#==' do
    context 'when versions have equal length' do
      it 'is false for non-equal versions' do
        expect(Version.new('1.2')).to_not be == Version.new('1.3')
        expect(Version.new('1.3')).to_not be == Version.new('1.2')
      end

      it 'is true for equal versions' do
        expect(Version.new('1.2')).to be == Version.new('1.2')
      end
    end

    context 'when versions have different length' do
      it 'is false for non-equal versions' do
        expect(Version.new('1.3.1')).to_not be == Version.new('1.3')
        expect(Version.new('1.3')).to_not be == Version.new('1.3.1')
      end

      it 'is true for equal versions' do
        expect(Version.new('1.3')).to be == Version.new('1.3.0')
      end
    end
  end

  describe '#<=>' do
    context 'when versions have equal length' do
      it 'compares smaller with larger version' do
        expect(Version.new('1.2') <=> Version.new('1.3')).to eq -1
      end

      it 'compares larger with smaller version' do
        expect(Version.new('1.3') <=> Version.new('1.2')).to eq 1
      end

      it 'compares equal versions' do
        version = Version.new('1.2')
        expect(version <=> Version.new('1.2')).to eq 0
      end
    end

    context 'when versions have different length' do
      it 'compares smaller with larger version' do
        expect(Version.new('1.3') <=> Version.new('1.3.1')).to eq -1
      end

      it 'compares larger with smaller version' do
        expect(Version.new('1.3.1') <=> Version.new('1.3')).to eq 1
      end

      it 'compares equal versions' do
        expect(Version.new('1.3') <=> Version.new('1.3.0')).to eq 0
      end
    end
  end

  describe '#to_s' do
    context 'when version does not have ending zeros' do
      it 'shows basic version' do
        expect(Version.new('1.3').to_s).to eq '1.3'
      end

      it 'shows the empty version' do
        expect(Version.new('').to_s).to eq ''
      end
    end

    context 'when version has ending zeros' do
      it 'shows basic version' do
        expect(Version.new('1.3.0').to_s).to eq '1.3'
      end

      it 'shows the 0 version' do
        expect(Version.new('0').to_s).to eq ''
      end
    end
  end

  describe '#components' do
    context 'when no optional argument is given' do
      it 'gets simple version' do
        expect(Version.new('1.2').components).to eq([1, 2])
      end

      it 'gets version ending with zero' do
        expect(Version.new('1.2.0').components).to eq([1, 2])
      end

      it 'does not modify the version' do
        version = Version.new('1.2')
        version.components.push -1

        expect(version.components).to eq([1, 2])
      end
    end

    context 'when optional argument is given' do
      it 'gets simple version with fewer elements' do
        expect(Version.new('1.2.3').components(5)).to eq([1, 2, 3, 0, 0])
      end

      it 'gets simple version with more elements' do
        expect(Version.new('1.2.3').components(2)).to eq([1, 2])
      end

      it 'gets simple version with equal amount of elements' do
        expect(Version.new('1.2.3').components(3)).to eq([1, 2, 3])
      end
    end
  end

  describe '#Version::Range' do
    describe '#initialize' do
      it 'does not raise error with valid versions' do
        expect { Version::Range.new('1.2.3', '1.2.4') }.to_not raise_error
      end

      it 'raises error with invalid versions' do
        version = '..3'
        expect { Version::Range.new(version, '1.2.4') }.to raise_error(
          ArgumentError,
          "Invalid version string '#{version}'"
        )
      end
    end

    describe '#include?' do
      it 'returns true for simple version' do
        range = Version::Range.new('1.2.3', '1.2.9')
        expect(range.include?('1.2.5')).to be true
      end

      it 'returns false for simple version' do
        range = Version::Range.new('1.2.3', '1.2.9')
        expect(range.include?('1.2.2')).to be false
      end

      it 'returns false when version is equal to last version in range' do
        range = Version::Range.new('1.2.3', '1.2.9')
        expect(range.include?('1.2.9')).to be false
      end

      it 'returns true when version is equal to first version in range' do
        range = Version::Range.new('1.2.3', '1.2.9')
        expect(range.include?('1.2.3')).to be true
      end
    end

    describe '#to_a' do
      it 'shows for simple range' do
        range = Version::Range.new('1.2.6', '1.3.1')
        expect(range.to_a.map(&:to_s)).to eq(
          [
            '1.2.6', '1.2.7',
            '1.2.8', '1.2.9', '1.3'
          ]
        )
      end

      it 'shows for range with shorter version' do
        range = Version::Range.new('1.2', '1.3')
        expect(range.to_a.map(&:to_s)).to eq(
          [
            '1.2', '1.2.1', '1.2.2',
            '1.2.3', '1.2.4', '1.2.5',
            '1.2.6', '1.2.7', '1.2.8', '1.2.9'
          ]
        )
      end

      it 'shows for range with no versions' do
        range = Version::Range.new('1.2', '1.2')
        expect(range.to_a.map(&:to_s)).to eq([])
      end
    end
  end
end