package com.example.multiservice_zayn.Service;

import com.example.multiservice_zayn.Model.contacte;
import com.example.multiservice_zayn.Repository.ContacteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ContacteService {

    @Autowired
    private ContacteRepository contacteRepository;

    public contacte saveContacte(contacte Contacte) {
        return contacteRepository.save(Contacte);
    }

    public List<contacte> getAllContactes() {
        return contacteRepository.findAll();
    }

    public contacte getContacteById(String id) {
        return contacteRepository.findById(id).orElse(null);
    }

    public void deleteContacte(String id) {
        contacteRepository.deleteById(id);
    }
}
