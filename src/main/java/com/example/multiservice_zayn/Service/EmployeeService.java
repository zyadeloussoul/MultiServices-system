package com.example.multiservice_zayn.Service;

import com.example.multiservice_zayn.Model.Employee;
import com.example.multiservice_zayn.Model.User;
import com.example.multiservice_zayn.Repository.EmployeeRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class EmployeeService {

    @Autowired
    private EmployeeRepo employeeRepo;

    public List<Employee> getAllEmployees() {
        List<Employee> users = employeeRepo.findAll();
        return users.stream()
                .filter(user -> user.getRole() == User.UserRole.EMPLOYEE)
                .map(user -> (Employee) user)  // Cast User to Employee
                .collect(Collectors.toList());
    }

    public Employee getEmployeeById(String id) {
        return employeeRepo.findById(id)
                .filter(user -> user.getRole() == User.UserRole.EMPLOYEE)
                .map(user -> (Employee) user)
                .orElse(null);
    }
}
