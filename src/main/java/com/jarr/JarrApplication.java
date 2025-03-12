package com.jarr;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan({"data.*","naver.storage"})
@MapperScan("data.mapper")
public class JarrApplication {

	public static void main(String[] args) {
		SpringApplication.run(JarrApplication.class, args);
	}

}
