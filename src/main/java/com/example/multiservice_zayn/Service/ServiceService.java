package com.example.multiservice_zayn.Service;

import com.example.multiservice_zayn.Model.ServiceEntity;
import com.example.multiservice_zayn.Repository.ServiceRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class ServiceService {

    @Autowired
    private ServiceRepo serviceRepository;

    // Get all services
    public List<ServiceEntity> getAllServices() {
        return serviceRepository.findAll();
    }

    // Get services by category
    public List<ServiceEntity> getServicesByCategory(String category) {
        return serviceRepository.findByCategory(category);
    }

    // Add a new service
    public ServiceEntity addService(ServiceEntity service) {
        return serviceRepository.save(service);
    }

    // Update a service
    public ResponseEntity<ServiceEntity> updateService(String name, ServiceEntity serviceDetails) {
        ServiceEntity service = serviceRepository.findByName(name);

        if (service != null) {
            service.setName(serviceDetails.getName());
            service.setTitle(serviceDetails.getTitle());
            service.setSubtitle(serviceDetails.getSubtitle());
            service.setCategory(serviceDetails.getCategory());
            service.setDescription(serviceDetails.getDescription());
            service.setImage(serviceDetails.getImage());

            return ResponseEntity.ok(serviceRepository.save(service));
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    // Delete a service
    public ResponseEntity<Void> deleteService(String name) {
        ServiceEntity service = serviceRepository.findByName(name);
        if (service != null) {
            serviceRepository.delete(service);
            return ResponseEntity.ok().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }


    // Get unique categories from services
    public List<String> getCategories() {
        List<ServiceEntity> services = serviceRepository.findAll();
        Set<String> categories = services.stream()
                .map(ServiceEntity::getCategory)
                .collect(Collectors.toSet());
        return new ArrayList<>(categories);
    }

}

