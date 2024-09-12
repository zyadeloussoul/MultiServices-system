package com.example.multiservice_zayn.Service;

import com.example.multiservice_zayn.Model.Employee;
import com.example.multiservice_zayn.Repository.EmployeeRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeService {

    @Autowired
    private EmployeeRepo employeeRepo;

    public List<Employee> getAllEmployees() {
        return employeeRepo.findAll();
    }

    public Employee getEmployeeById(String id) {
        return employeeRepo.findById(id).orElse(null);
    }

    // Methods for managing services (add, delete, modify)
    // Example:
    public void manageService() {
        // Logic for managing services
    }
}
