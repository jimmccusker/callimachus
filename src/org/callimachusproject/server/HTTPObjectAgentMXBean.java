/*
 * Copyright (c) 2010, Zepheira LLC, Some rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * - Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution. 
 * - Neither the name of the openrdf.org nor the names of its contributors may
 *   be used to endorse or promote products derived from this software without
 *   specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 * 
 */
package org.callimachusproject.server;

import java.io.IOException;

/**
 * MXBean interface for client and server.
 * 
 * @author James Leigh
 * 
 */
public interface HTTPObjectAgentMXBean {

	String getName();

	void setName(String name);

	String getFrom();

	void setFrom(String from);

	String getStatus();

	ConnectionBean[] getConnections();

	void connectionDumpToFile(String outputFile) throws IOException;

	boolean isCacheEnabled();

	void setCacheEnabled(boolean cacheEnabled);

	boolean isCacheAggressive();

	void setCacheAggressive(boolean cacheAggressive);

	boolean isCacheDisconnected();

	void setCacheDisconnected(boolean cacheDisconnected);

	int getCacheCapacity();

	void setCacheCapacity(int capacity);

	int getCacheSize();

	void poke();

	void invalidateCache() throws Exception;

	void resetCache() throws Exception;

	void resetConnections() throws IOException;

	void start() throws Exception;

	void stop() throws Exception;

	void destroy() throws Exception;
}
