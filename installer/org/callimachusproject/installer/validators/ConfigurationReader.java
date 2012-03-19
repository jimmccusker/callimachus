/*
 * Copyright (c) 2012 3 Round Stones Inc., Some Rights Reserved
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
package org.callimachusproject.installer.validators;
import java.io.File;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.callimachusproject.installer.Configure;

import com.izforge.izpack.installer.AutomatedInstallData;
import com.izforge.izpack.installer.DataValidator;

/**
 * A custom IzPack (see http://izpack.org) validator to validate
 * the status of com.izforge.izpack.panels.CallimachusConfigurationPanel.
 * 
 * @author David Wood (david @ http://3roundstones.com)
 * 
 */
public class ConfigurationReader implements DataValidator {
    
	protected AutomatedInstallData adata;
	protected Map<String,String> defaults = new HashMap<String,String>(20); // Default values for variables.
	public static Configure configure;
    
    public boolean getDefaultAnswer() {
        return true;
    }
    
    public String getErrorMessageId() {
        return "CallimachusConfigurationValidator reported an error.  Run this installer from a command line for a full stack trace.";
    }
    
    public String getWarningMessageId() {
        return "CallimachusConfigurationValidator reported a warning.  Run this installer from a command line for a full stack trace.";
    }
    
    public DataValidator.Status validateData(AutomatedInstallData adata) {

        this.adata = adata;
        initializeDefaults();
        
        try {
			if (configure == null) {
				String installPath = adata.getInstallPath();
				configure = new Configure(new File(installPath));
				if (configure.isServerRunning() && !configure.stopServer()) {
					System.err.println("Server must be shut down to continue");
	    			return Status.ERROR;
	    		}
			}

			// Set IzPack variables for callimachus.conf:
			String[] confProperties = {"PORT", "ALL_LOCAL", "OTHER_REALM"};
			setCallimachusVariables(configure.getServerConfiguration(), confProperties);
            setOriginVariables(configure.getServerConfiguration());

			// Set IzPack variables for mail.properties:
			String[] mailProperties = {"mail.transport.protocol", "mail.from", "mail.smtps.host", "mail.smtps.port", "mail.smtps.auth", "mail.user", "mail.password"};
			setCallimachusVariables(configure.getMailProperties(), mailProperties);
		} catch (Exception e) {
			// This is an unknown error.
    		e.printStackTrace();
			return Status.ERROR;
		}
        
        return Status.OK;
    }
    
    /**
	 * Set IzPack variables for each property provided.
	 *
	 * @param prop A Java Properties object holding values from a Callimachus config file.
	 * @param properties A list of property names to convert to IzPack variables.
	 */
	private void setCallimachusVariables(Properties prop, String[] properties) {
		// Get the values of relevant properties and convert them to IzPack
		// variables with the same names but prepended by "callimachus." to
		// avoid namespace conflicts.
		String tempProperty;
		int propertiesLength = properties.length;
		for (int i = 0; i < propertiesLength; i++) {
			if ( prop.getProperty(properties[i]) == null ) {
			    tempProperty = defaults.get(properties[i]);
			} else {
				tempProperty = prop.getProperty(properties[i]);
			}
			adata.setVariable("callimachus." + properties[i], tempProperty);
		}
	}

    /**
	 * Set IzPack variables for the origin variable.
	 *
	 * @param prop A Java Properties object holding values from a Callimachus config file.
	 */
	private void setOriginVariables(Properties prop) {
	    String origin = prop.getProperty("PRIMARY_ORIGIN");
        if ( origin == null ) {
            origin = defaults.get("PRIMARY_ORIGIN");
        }
        String[] origins = origin.split("\\s+");
        String[] properties = {"PRIMARY_ORIGIN", "SECONDARY_ORIGIN"};
		String tempProperty;
		// Use the on-disk values for any variable.
		for (int i = 0; i < origins.length; i++) {
			if ( origins[i] == null ) {
			    tempProperty = defaults.get(properties[i]);
			} else {
				tempProperty = origins[i];
			}
    		adata.setVariable("callimachus." + properties[i], tempProperty);
		}
		// Write default values for anything not on disk.
		for (int i = origins.length; i < properties.length; i++) {
		    tempProperty = defaults.get(properties[i]);
		    adata.setVariable("callimachus." + properties[i], tempProperty);
		}
	}
	
	/**
	 * Initializes the default configuration variable values.
	 *
	 */
	private void initializeDefaults() {
	    defaults.put("PORT", "8080");
    	defaults.put("PRIMARY_ORIGIN", "http://localhost:8080");
        defaults.put("mail.transport.protocol", "smtps");
        defaults.put("mail.from", "user@example.com");
        defaults.put("mail.smtps.host", "mail.example.com");
        defaults.put("mail.smtps.port", "465");
        defaults.put("mail.smtps.auth", "no");
        defaults.put("mail.user", "");
        defaults.put("mail.password", "");
        defaults.put("SECONDARY_ORIGIN", "");
        defaults.put("ALL_LOCAL", "true");
        defaults.put("OTHER_REALM", "");
	}
}