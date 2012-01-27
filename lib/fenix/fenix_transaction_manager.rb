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