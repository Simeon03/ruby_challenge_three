require_relative '../lib/password_manager_2'
load "#{__dir__}/solution.x.rb" if File.file?("#{__dir__}/solution.x.rb")
require 'time'

RSpec.describe PasswordManager2 do
  describe '#add' do
    context 'when the password and service name are unique' do
      it 'is added successfully' do
        password_manager = PasswordManager2.new
        password_manager.add('acebook', 'password123')
        password_manager.add('makersbnb', 'qwerty789')
        expect(password_manager.services).to eq ['acebook', 'makersbnb']
      end
    end

    context 'when the password is not unique' do

      it 'a helpful message is returned' do
        password_manager = PasswordManager2.new
        password_manager.add('acebook', 'password123')
        expect(password_manager.add('makersbnb', 'password123')).to eq(
          "ERROR: Passwords must be unique"
        )
      end

      it 'is not added' do
        password_manager = PasswordManager2.new
        password_manager.add('acebook', 'password123')
        password_manager.add('makersbnb', 'password123')
        expect(password_manager.services).to eq(['acebook'])
      end
    end

    context 'when the service name is not unique' do
      it 'a helpful message is returned' do
        password_manager = PasswordManager2.new
        password_manager.add('acebook', 'password123')
        expect(password_manager.add('acebook', 'qwerty789')).to eq(
          "ERROR: Service names must be unique"
        )
      end

      it 'is not added' do
        password_manager = PasswordManager2.new
        password_manager.add('acebook', 'password123')
        password_manager.add('acebook', 'qwerty789')
        expect(password_manager.services).to eq ['acebook']
      end
    end
  end

  describe '#remove' do
    it 'removes a service' do
      password_manager = PasswordManager2.new
      password_manager.add('acebook', 'password123')
      password_manager.remove('acebook')
      expect(password_manager.services).to eq []
    end
  end

  describe '#update' do
    context 'when the updated password is unique' do
      it 'is updated successfully' do
        password_manager = PasswordManager2.new
        password_manager.add('acebook', 'password123')
        password_manager.add('makersbnb', 'qwerty789')
        password_manager.update('acebook', 'newpassword456')
        expect(password_manager.password_for('acebook')).to eq 'newpassword456'
      end
    end

    context 'whe the updated password is not unique' do
      it 'is not updated' do
        password_manager = PasswordManager2.new
        password_manager.add('acebook', 'password123')
        password_manager.add('makersbnb', 'qwerty789')
        password_manager.update('acebook', 'qwerty789')
        expect(password_manager.password_for('acebook')).to eq 'password123'
      end
    end
  end

  describe '#sort_by' do
    it 'can sort by service name, alphabetically' do
      password_manager = PasswordManager2.new
      password_manager.add('acebook', 'password123')
      password_manager.add('chitter', 'cheepcheep123')
      password_manager.add('makersbnb', 'qwerty789')
      expect(password_manager.sort_by('service')).to eq [
        'acebook',
        'chitter',
        'makersbnb'
      ]
    end

    it 'can sort by added_on date, chronologically' do
      password_manager = PasswordManager2.new
      Timecop.freeze(Time.local(2020, 1, 1)) do
        password_manager.add('acebook', 'password123')
      end
      Timecop.freeze(Time.local(2019, 1, 1)) do
        password_manager.add('makersbnb', 'qwerty789')
      end
      Timecop.freeze(Time.local(2018, 1, 1)) do
        password_manager.add('chitter', 'cheepcheep123')
      end
      expect(password_manager.sort_by('added_on')).to eq [
        'chitter',
        'makersbnb',
        'acebook'
      ]
    end
  end
end