# 
# Execute Synthea ETL Builder from Windows command line
#
# Usage: C:> Rscript SyntheaWindowsBulkLoader.r postgresql localhost synthea_v2 public public postgres postgres D:\Apps\Git\synthea\output\csv D:\synthea\V2\csv\vocabulary 5432
# 

SyntheaWindowsBulkLoader <- function(dbms, server, dbName, syntheaSchema, vocabSchema, username, password, syntheaFileLoc, vocabFileLoc, port) 
{

cd <- DatabaseConnector::createConnectionDetails(
  dbms     = dbms, 
  server   = paste0(server,"/",dbName),
  user     = username, 
  password = password, 
  port     = port
)

    ETLSyntheaBuilder::DropCDMTables(cd,vocabSchema)
    ETLSyntheaBuilder::DropSyntheaTables(cd,syntheaSchema)
    ETLSyntheaBuilder::CreateCDMTables(cd,vocabSchema)
    ETLSyntheaBuilder::CreateSyntheaTables(cd,syntheaSchema)
    ETLSyntheaBuilder::LoadSyntheaTables(cd,syntheaSchema,syntheaFileLoc)
    ETLSyntheaBuilder::LoadVocabTables(cd,vocabSchema,vocabFileLoc)
    ETLSyntheaBuilder::CreateVocabMapTables(cd,vocabSchema)
    ETLSyntheaBuilder::CreateVisitRollupTables(cd,vocabSchema,syntheaSchema)
    ETLSyntheaBuilder::LoadCDMTables(cd,vocabSchema,syntheaSchema)
}

args <- commandArgs(trailingOnly=TRUE)
SyntheaWindowsBulkLoader(args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10])
