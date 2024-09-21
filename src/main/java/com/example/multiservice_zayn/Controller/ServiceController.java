package com.example.multiservice_zayn.Controller;

import com.example.multiservice_zayn.Model.ServiceEntity;
import com.example.multiservice_zayn.Service.ServiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/services")
public class ServiceController {

    @Autowired
    private ServiceService serviceService;

    // Endpoint to get all services (accessible by all users)
    @GetMapping
    public List<ServiceEntity> getAllServices() {
        return serviceService.getAllServices();
    }

    // Endpoint to get services by category
    @GetMapping("/category/{categoryName}")
    public List<ServiceEntity> getServicesByCategory(@PathVariable String categoryName) {
        return serviceService.getServicesByCategory(categoryName);
    }

    // Endpoint to add a new service (accessible by ADMIN and EMPLOYEE)
    @PreAuthorize("hasAnyRole('ADMIN', 'EMPLOYEE')")
    @PostMapping
    public ServiceEntity addService(@RequestBody ServiceEntity serviceEntity) {
        return serviceService.addService(serviceEntity);
    }

    // Endpoint to update a service (accessible by ADMIN and EMPLOYEE)
    @PreAuthorize("hasAnyRole('ADMIN', 'EMPLOYEE')")
    @PutMapping("/{name}")
    public ResponseEntity<ServiceEntity> updateService(@PathVariable String name, @RequestBody ServiceEntity serviceDetails) {
        return serviceService.updateService(name, serviceDetails);
    }

    // Endpoint to delete a service by name (accessible by ADMIN and EMPLOYEE)
    @PreAuthorize("hasAnyRole('ADMIN', 'EMPLOYEE')")
    @DeleteMapping("/delete/{name}")
    public ResponseEntity<Void> deleteService(@PathVariable String name) {
        return serviceService.deleteService(name);
    }

    // Endpoint to get unique categories from services
    @GetMapping("/categories")
    public List<String> getCategories() {
        return serviceService.getCategories();
    }
}
