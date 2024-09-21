package com.example.multiservice_zayn.Service;

import com.example.multiservice_zayn.Model.Employee;
import com.example.multiservice_zayn.Model.User;
import com.example.multiservice_zayn.Repository.EmployeeRepo;
import com.example.multiservice_zayn.Repository.UserRepo;
import jakarta.transaction.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.nio.file.AccessDeniedException;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class EmployeeService {
    @Autowired
    private UserService userService;
    @Autowired
    private EmployeeRepo employeeRepo;
    @Autowired
    private UserRepo userRepo;
    @Autowired
    private PasswordEncoder passwordEncoder;
    private static final Logger logger = LoggerFactory.getLogger(EmployeeService.class);

    public User getCurrentAuthenticatedUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication != null && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken)) {

            // Retrieve the principal (user details)
            Object principal = authentication.getPrincipal();

            if (principal instanceof UserDetails) {
                String username = ((UserDetails) principal).getUsername();

                // Fetch the user from your userRepo by username
                User user = userRepo.findByUsername(username);

                // Log the authenticated user's details for debugging
                System.out.println("Authenticated user: " + user.getUsername() + ", Role: " + user.getRole());

                return user;
            }
        }

        return null; // Return null if authentication fails
    }


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

    public Employee addEmployee(Employee employee) throws AccessDeniedException {
        // Ensure the employee role is correct
        if (employee.getRole() != User.UserRole.EMPLOYEE) {
            throw new IllegalArgumentException("Role must be EMPLOYEE");
        }

        // Only ADMIN can add employees
        User currentUser = getCurrentAuthenticatedUser();
        if (currentUser == null || currentUser.getRole() != User.UserRole.ADMIN) {
            throw new AccessDeniedException("Only ADMIN can add employees");
        }

        return employeeRepo.save((Employee) employee);
    }

    @Transactional
    public boolean deleteEmployeeById(String id) throws AccessDeniedException {
        logger.debug("Attempting to delete employee with id: " + id);

        // Step 1: Authenticate and ensure the user has the ADMIN role
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        logger.debug("Current authentication: " + authentication);

        if (!(authentication.getPrincipal() instanceof UserDetails)) {
            logger.error("Authentication principal is not an instance of UserDetails");
            throw new AccessDeniedException("Invalid authentication");
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        boolean isAdmin = userDetails.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

        logger.debug("Is user admin? " + isAdmin);

        if (!isAdmin) {
            logger.warn("Access denied: User does not have ADMIN role");
            throw new AccessDeniedException("Only ADMIN can delete employees");
        }

        logger.debug("User has ADMIN role, proceeding with deletion");

        // Step 2: Select the EMPLOYEE with the given id
        Optional<Employee> employeeOptional = employeeRepo.findById(id);

        if (employeeOptional.isPresent()) {
            Employee employee = employeeOptional.get();
            logger.debug("Found employee: " + employee);

            // Step 3: Delete the EMPLOYEE
            employeeRepo.deleteById(id);
            logger.info("Employee deleted successfully: " + id);
            return true;
        } else {
            logger.warn("No employee found with id: " + id);
            return false;
        }
    }

    @Transactional
    public Employee updateEmployee(String id, Employee updatedEmployee) throws AccessDeniedException {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (!(authentication.getPrincipal() instanceof UserDetails)) {
            throw new AccessDeniedException("Invalid authentication");
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        boolean isAdmin = userDetails.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

        if (!isAdmin) {
            throw new AccessDeniedException("Only ADMIN can update employees");
        }

        Optional<Employee> existingEmployeeOpt = employeeRepo.findById(id);
        if (existingEmployeeOpt.isEmpty()) {
            throw new RuntimeException("No employee found with id: " + id);
        }

        Employee existingEmployee = existingEmployeeOpt.get();
        existingEmployee.setUsername(updatedEmployee.getUsername());
        existingEmployee.setEmail(updatedEmployee.getEmail());

        if (updatedEmployee.getPassword() != null && !updatedEmployee.getPassword().isEmpty()) {
            existingEmployee.setPassword(passwordEncoder.encode(updatedEmployee.getPassword()));
        }

        existingEmployee.setAddress(updatedEmployee.getAddress());
        existingEmployee.setPosition(updatedEmployee.getPosition());

        return employeeRepo.save(existingEmployee);
    }
}