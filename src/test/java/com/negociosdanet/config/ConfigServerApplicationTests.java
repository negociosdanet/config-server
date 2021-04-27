package com.negociosdanet.config;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import static org.assertj.core.api.Assertions.assertThat;

@RunWith(SpringRunner.class)
@SpringBootTest
public class ConfigServerApplicationTests {

	@Mock
	private ConfigServerApplication configServerApplication;

	@Test
	public void contextLoads() {
		String[] strings = new String[1];
		strings[0] = this.getClass().getName();
		ConfigServerApplication.main(strings);
		assertThat(configServerApplication).isNotNull();
	}

}
