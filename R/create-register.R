# Create the register from the latest Charities data

library(tidyverse)
library(here)

# Import the data --------------------------------------------------------------

acct_submit_path <- here("lists", "extract_acct_submit.bcp")
aoo_ref_path <- here("lists", "extract_aoo_ref.bcp")
ar_submit_path <- here("lists", "extract_ar_submit.bcp")
charity_path <- here("lists", "extract_charity.bcp")
charity_aoo_path <- here("lists", "extract_charity_aoo.bcp")
class_path <- here("lists", "extract_class.bcp")
class_ref_path <- here("lists", "extract_class_ref.bcp")
financial_path <- here("lists", "extract_financial.bcp")
main_charity_path <- here("lists", "extract_main_charity.bcp")
name_path <- here("lists", "extract_name.bcp")
objects_path <- here("lists", "extract_objects.bcp")
partb_path <- here("lists", "extract_partb.bcp")
registration_path <- here("lists", "extract_registration.bcp")
remove_ref_path <- here("lists", "extract_remove_ref.bcp")
trustee_path <- here("lists", "extract_trustee.bcp")

acct_submit_colnames <- c("regno", "submit_date", "arno", "fyend")
aoo_ref_colnames <- c("aootype", "aookey", "aooname", "aoosort", "welsh", "master")
ar_submit_colnames <- c("regno", "arno", "submit_date")
charity_colnames <- c("regno", "subno", "name", "orgtype", "gd", "aob", "aob_defined", "nhs", "ha_no", "corr", "add1", "add2", "add3", "add4", "add5", "postcode", "phone", "fax")
charity_aoo_colnames <- c("regno", "aootype", "aookey", "welsh", "master")
class_colnames <- c("regno", "class")
class_ref_colnames <- c("classno", "classtext")
financial_colnames <- c("regno", "fystart", "fyend", "income", "expend")
main_charity_colnames <- c("regno", "coyno", "trustees", "fyend", "welsh", "incomedate", "income", "grouptype", "email", "web")
name_colnames <- c("regno", "subno", "nameno", "name")
objects_colnames <- c("regno", "subno", "seqno", "object")
# partb_colnames <- c() # 45 columns of financials
registration_colnames <- c("regno", "subno", "regdate", "remdate", "remcode")
remove_ref_colnames <- c("code", "text")
trustee_colnames <- c("regno", "trustee")

acct_submit <- read_tsv(acct_submit_path, col_names = acct_submit_colnames, quote = "")
aoo_ref <- read_tsv(aoo_ref_path, col_names = aoo_ref_colnames, quote = "")
ar_submit <- read_tsv(ar_submit_path, col_names = ar_submit_colnames, quote = "")
charity <- read_tsv(charity_path, col_names = charity_colnames, quote = "")
charity_aoo <- read_tsv(charity_aoo_path, col_names = charity_aoo_colnames, quote = "")
class <- read_tsv(class_path, col_names = class_colnames, quote = "")
class_ref <- read_tsv(class_ref_path, col_names = class_ref_colnames, quote = "")
financial <- read_tsv(financial_path, col_names = financial_colnames, quote = "")
main_charity <- read_tsv(main_charity_path, col_names = main_charity_colnames, quote = "")
name <- read_tsv(name_path, col_names = name_colnames, quote = "")
objects <- read_tsv(objects_path, col_names = objects_colnames, quote = "")
partb <- read_tsv(partb_path, col_names = FALSE, quote = "")
registration <- read_tsv(registration_path, col_names = registration_colnames, quote = "")
remove_ref <- read_tsv(remove_ref_path, col_names = remove_ref_colnames, quote = "")
trustee <- read_tsv(trustee_path, col_names = trustee_colnames, quote = "")

# Boring checks ----------------------------------------------------------------

# Are all charities distinct? Yes, by regno & subno
nrow(charity) == nrow(distinct(charity, regno))
nrow(charity) == nrow(distinct(charity, regno, subno))

map(charity, anyNA)

# One charity has no name
filter(charity, is.na(name))

# All charities have an orgtype: R = registered, RM = Removed
# The registration table has each period of registration per charity

# All registrations have a regdate
map(registration, anyNA)

# Registrations are distinct by regno, subno and regdate
nrow(registration) == nrow(distinct(registration, regno, subno, regdate))

# But registrations are not quite disttinct by remdate -- can there be overlaps?
nrow(registration) == nrow(distinct(registration, regno, subno, remdate))

# 13 pairs of registrations overlap.  The remcodes agree within pairs.
registration %>%
  group_by(regno, subno, remdate) %>%
  mutate(n = n()) %>%
  ungroup() %>%
  filter(n > 1) %>%
  print(n = Inf)

# We could combine the overlapping periods like this
registration <-
  registration %>%
  group_by(regno, subno, remdate) %>%
  summarise(regdate = min(regdate),
            remcode = first(remcode)) %>%
  ungroup() %>%
  select(regno, subno, regdate, remdate, remcode)

# Now there are no overlaps
registration %>%
  group_by(regno, subno, remdate) %>%
  mutate(n = n()) %>%
  ungroup() %>%
  filter(n > 1) %>%
  print(n = Inf)

# 3453 remdates don't have remcodes
filter(registration, !is.na(remdate), is.na(remcode))

# Do registrations accord with orgtype?
latest_registration <-
  registration %>%
  group_by(regno, subno) %>%
  arrange(desc(regdate)) %>%
  slice(1) %>%
  ungroup()

anti_join(charity, latest_registration, by = c("regno", "subno")) # 0 rows, good
anti_join(latest_registration, charity, by = c("regno", "subno")) # 0 rows, good

# 550 charity orgtypes don't agree with registrations
latest_registration %>%
  transmute(regno,
            subno,
            orgtype = if_else(is.na(remdate), "R", "RM")) %>%
  inner_join(select(charity, regno, subno, orgtype),
             by = c("regno", "subno")) %>%
  filter(orgtype.x != orgtype.y) %>%
  count(orgtype.x)
