package com.example.multiservice_zayn.Controller;

import com.example.multiservice_zayn.Model.contacte;
import com.example.multiservice_zayn.Service.ContacteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/contactes")
public class ContacteController {

    @Autowired
    private ContacteService contacteService;

    @PostMapping
    public ResponseEntity<contacte> createContacte(@RequestBody contacte contacte) {
        contacte savedContacte = contacteService.saveContacte(contacte);
        return new ResponseEntity<>(savedContacte, HttpStatus.CREATED);
    }

    @GetMapping
    public ResponseEntity<List<contacte>> getAllContactes() {
        List<contacte> contactes = contacteService.getAllContactes();
        return new ResponseEntity<>(contactes, HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<contacte> getContacteById(@PathVariable String id) {
        contacte contacte = contacteService.getContacteById(id);
        if (contacte != null) {
            return new ResponseEntity<>(contacte, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteContacte(@PathVariable String id) {
        contacteService.deleteContacte(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
}
