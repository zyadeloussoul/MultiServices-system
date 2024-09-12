package com.example.multiservice_zayn.Repository;

import com.example.multiservice_zayn.Model.Employee;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface EmployeeRepo extends MongoRepository<Employee, String> {
}
