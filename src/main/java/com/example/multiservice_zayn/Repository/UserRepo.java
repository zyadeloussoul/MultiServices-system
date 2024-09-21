package com.example.multiservice_zayn.Repository;


import com.example.multiservice_zayn.Model.Employee;
import com.example.multiservice_zayn.Model.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepo extends MongoRepository<User, String> {
    User findByEmail(String email);
    User findByUsername(String username);
    User save(Employee employee);
    User findByRole(User.UserRole role);

    void delete(User user);
}