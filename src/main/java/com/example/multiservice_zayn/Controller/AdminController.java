package com.example.multiservice_zayn.Controller;

import com.example.multiservice_zayn.Model.Employee; // Changed from adminEmploye to Employee
import com.example.multiservice_zayn.Service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AdminService adminService;

    @PostMapping("/addEmployee")
    public Employee addEmployee(@RequestBody Employee employee) { // Changed from adminEmploye to Employee
        return adminService.addEmployee(employee);
    }

    @DeleteMapping("/deleteEmployee/{id}")
    public void deleteEmployee(@PathVariable String id) {
        adminService.deleteEmployee(id);
    }

    @PutMapping("/updateEmployee")
    public Employee updateEmployee(@RequestBody Employee employee) { // Changed from adminEmploye to Employee
        return adminService.updateEmployee(employee);
    }

    @GetMapping("/getEmployee/{id}")
    public Employee getEmployeeById(@PathVariable String id) { // Changed from adminEmploye to Employee
        return adminService.getEmployeeById(id);
    }
}
