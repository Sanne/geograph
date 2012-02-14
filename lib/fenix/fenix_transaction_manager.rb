###############################################################################
###############################################################################
#
# This file is part of GeoGraph.
#
# Copyright (c) 2012 Algorithmica Srl
#
# GeoGraph is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# GeoGraph is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with GeoGraph.  If not, see <http://www.gnu.org/licenses/>.
#
# Contact us via email at info@algorithmica.it or at
#
# Algorithmica Srl
# Vicolo di Sant'Agata 16
# 00153 Rome, Italy
#
###############################################################################
###############################################################################

module Fenix
  IllegalWriteException = Java::PtIstFenixframeworkPstm::IllegalWriteException
  CommitException = Java::Jvstm::CommitException
  WriteOnReadException = Java::Jvstm::WriteOnReadException
  UnableToDetermineIdException = Java::PtIstFenixframeworkPstm::AbstractDomainObject::UnableToDetermineIdException
  PersistenceException = Java::PtIstFenixframeworkPstmRepository::PersistenceException

  # This is the Fenix Transaction Manager extension provided to resolve the issue:
  # Masquerading of native Java exceptions http://jira.codehaus.org/browse/JRUBY-1300.
  # To solve the issue we override the withTransaction method and we implement the same logic
  # of the Java version, in this way the exceptions are fired correctly.
  class FenixTransactionManager
    def withTransaction(&block)
      result = nil
      try_read_only = true

      while(true) do
        Java::PtIstFenixframeworkPstm::Transaction.begin(try_read_only)
        finished = false
        begin
          result = block.call
          Java::PtIstFenixframeworkPstm::Transaction.commit
          finished = true
          return result
        rescue CommitException => ce
          FenixTransaction.abort
          finished = true
        rescue WriteOnReadException => wore
          Rails.logger.debug "jvstm.WriteOnReadException"
          Java::PtIstFenixframeworkPstm::Transaction.abort
          finished = true
          try_read_only = false
        rescue UnableToDetermineIdException => unableToDetermineIdException
          Rails.logger.error "Restaring TX: unable to determine id. Cause: #{unableToDetermineIdException.getCause}"
          Rails.logger.error "#{unableToDetermineIdException}"
          Java::PtIstFenixframeworkPstm::Transaction.abort
          finished = true
        rescue PersistenceException => perc
          Rails.logger.error "PersistenceException. Cause: #{perc.getCause}"
          Java::PtIstFenixframeworkPstm::Transaction.abort
          finished = true
        ensure
          unless finished
            Java::PtIstFenixframeworkPstm::Transaction.abort
          end
        end
      end
    end
  end
  
end