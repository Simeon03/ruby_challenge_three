require 'date'


class PasswordManager2
    def initialize
        @password_manager = []
    end

    # Checks if service/password is unique
    def is_unique?(old, new)
        @password_manager.any?{ |manager| manager[old] == new}
    end

    # Finds a service/password
    def find(old, new)
        @password_manager.find{ |manager| manager[old] == new}
    end

    # Returns an error message if password is not unique
    def password_error_message
        "ERROR: Passwords must be unique"
    end

    # Returns an error message if service name is not unique
    def service_error_message
        "ERROR: Service names must be unique"
    end

    def add(service, password)
        if is_unique?("password", password)
            password_error_message
        elsif is_unique?("service", service)
            service_error_message
        else
            add = {'service' => service, 'password' => password, 'added_on' => DateTime.now(), 'updated' => DateTime.now()}
            @password_manager.push(add)
        end
    end

    def remove(service)
        @password_manager.delete(find('service', service))
    end

    def services
        @password_manager.map { |manager| manager['service']}
    end

    def sort_by(condition)
        sorting = @password_manager.sort_by { |manager| manager[condition]}
        sorting.map{ |manager| manager['service']}
    end

    def password_for(service)
        entry = find('service', service)
        entry['password']
    end

    def update(service, new_password)
        is_unique?("password", new_password) ? "ERROR: Passwords must be unique" : find('service', service)["password"] = new_password
    end
    


end
