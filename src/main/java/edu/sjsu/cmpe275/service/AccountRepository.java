package edu.sjsu.cmpe275.service;

import edu.sjsu.cmpe275.domain.Account;
import org.springframework.data.repository.CrudRepository;

public interface AccountRepository extends CrudRepository<String, Account> {
}
