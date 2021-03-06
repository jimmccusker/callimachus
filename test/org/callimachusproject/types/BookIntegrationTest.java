/*
 * Copyright (c) 2013 3 Round Stones Inc., Some Rights Reserved
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
package org.callimachusproject.types;

import org.callimachusproject.test.TemporaryServerIntegrationTestCase;
import org.callimachusproject.test.WebResource;
import org.junit.Test;

public class BookIntegrationTest extends TemporaryServerIntegrationTestCase {
	private static final String DOCBOOK = "<book version='5.0'  xmlns='http://docbook.org/ns/docbook' xmlns:xl='http://www.w3.org/1999/xlink'> \n" +
			"<title>LS command</title> \n " +
			"<article><title>article title</title><para>This command is a synonym for command. \n" +
			"</para></article> \n </book>";

	@Test
	public void testDocbookCreate() throws Exception {
		WebResource create = getHomeFolder().ref("?create="+ getCallimachusUrl("types/Book"));
		WebResource book = create.create("test-book.docbook", "application/docbook+xml", DOCBOOK.getBytes());
		WebResource edit = book.rel("edit-media", "application/docbook+xml");
		edit.get("application/docbook+xml");
		edit.put("application/docbook+xml", DOCBOOK.getBytes());
		book.rel("alternate", "application/docbook+xml").get("application/docbook+xml");
	}

}
