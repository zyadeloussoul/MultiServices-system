package com.example.multiservice_zayn.Repository;

import com.example.multiservice_zayn.Model.Employee;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.Optional;

public interface EmployeeRepo extends MongoRepository<Employee, String> {
    Employee save(Employee employee);
    Optional<Employee> findById(String id);
}
