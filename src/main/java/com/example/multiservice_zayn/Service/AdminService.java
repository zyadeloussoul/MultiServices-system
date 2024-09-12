package com.example.multiservice_zayn.Service;

import com.example.multiservice_zayn.Model.Employee;
import com.example.multiservice_zayn.Repository.UserRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class AdminService {

    @Autowired
    private UserRepo userRepo;

    public Employee addEmployee(Employee employee) {
        return (Employee) userRepo.save(employee);
    }

    public void deleteEmployee(String id) {
        userRepo.deleteById(id);
    }

    public Employee updateEmployee(Employee employee) {
        return (Employee) userRepo.save(employee);
    }

    public Employee getEmployeeById(String id) {
        return (Employee) userRepo.findById(id).orElse(null);
    }

    // Additional methods for specific admin tasks
}
