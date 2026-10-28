import unittest
from analyze import tokens,split_top,statements

class LexerTests(unittest.TestCase):
    def test_escaped_and_doubled_quotes(self):
        value="('a,;()','it\\'s','it''s',NULL),('x',2,3,4)"
        groups=split_top(value)
        self.assertEqual(len(groups),2)
        self.assertIn("'a,;()'",list(tokens(value)))
    def test_versioned_comment(self):
        self.assertEqual(list(tokens('/*!40000 ALTER TABLE `t` DISABLE KEYS */')),['ALTER','TABLE','`t`','DISABLE','KEYS'])
    def test_delimited_trigger_not_counted_as_insert(self):
        text="DELIMITER ;;\nCREATE TRIGGER `a` AFTER INSERT ON `t` FOR EACH ROW BEGIN\nINSERT INTO `t` VALUES ('x;');\nEND;;\nDELIMITER ;\nINSERT INTO `t` VALUES (NULL),(1);\n"
        result=list(statements(text));self.assertEqual(len(result),2)
        self.assertEqual([r[2][0] for r in result],['CREATE','INSERT'])
    def test_nested_constraints(self):
        self.assertEqual(len(split_top("`a` decimal(12,2), CHECK ((`a`>0) AND (`a`<100)), `b` enum('a,b','c')")),3)

if __name__=='__main__': unittest.main()
