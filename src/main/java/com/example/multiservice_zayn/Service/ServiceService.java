package com.example.multiservice_zayn.Service;

import com.example.multiservice_zayn.Model.ServiceEntity;
import com.example.multiservice_zayn.Repository.ServiceRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ServiceService {

    @Autowired
    private ServiceRepo serviceRepository;

    // Get all services
    public List<ServiceEntity> getAllServices() {
        return serviceRepository.findAll();
    }

    // Add a new service
    public ServiceEntity addService(ServiceEntity service) {
        return serviceRepository.save(service);
    }

    // Update a service
    public ResponseEntity<ServiceEntity> updateService(Long id, ServiceEntity serviceDetails) {
        Optional<ServiceEntity> optionalService = serviceRepository.findById(id);
        if (optionalService.isPresent()) {
            ServiceEntity service = optionalService.get();
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
    public ResponseEntity<Void> deleteService(Long id) {
        if (serviceRepository.existsById(id)) {
            serviceRepository.deleteById(id);
            return ResponseEntity.ok().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}