import PyPDF2
NOT_COUNTING_PAGES = 16
# pdf_file = open('../master.pdf', 'rb')
# read_pdf = PyPDF2.PdfFileReader(pdf_file)
# number_of_pages = read_pdf.getNumPages() - NOT_COUNTING_PAGES
number_of_pages = 10
page_file = open('pages.txt', 'w+')
progress_file = open('progress.txt', 'w+')
page_file.write(str(number_of_pages) + "\n")
progress_file.write(str(int(number_of_pages / 80 * 100)) +
                    '%-' + str(int(number_of_pages / 60 * 100)) + '%\n')
